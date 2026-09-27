package com.github.skeliit;

import com.github.skeliit.dao.SongDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.FileImageOutputStream;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.SQLException;
import java.util.Iterator;

/**
 * Upload or clear a song's preview image (Open Graph + YouTube placeholder).
 */
@WebServlet(name = "AdminSongPreviewServlet", urlPatterns = { "/admin/songs/preview" })
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class AdminSongPreviewServlet extends HttpServlet {

    private final SongDao songs = new SongDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Object role = req.getSession().getAttribute("role");
        if (role == null || !"ADMIN".equals(role.toString())) {
            resp.setStatus(403);
            return;
        }
        if (!CsrfFilter.isValid(req)) {
            resp.setStatus(403);
            resp.getWriter().write("CSRF");
            return;
        }

        int songId;
        try {
            songId = Integer.parseInt(req.getParameter("song_id"));
        } catch (Exception e) {
            resp.sendError(400, "missing song_id");
            return;
        }

        String action = req.getParameter("action");
        try {
            if ("delete".equals(action)) {
                deletePreview(songId);
                resp.sendRedirect(req.getContextPath() + "/admin/songs?msg=preview_deleted");
                return;
            }

            Part part = req.getPart("preview");
            if (part == null || part.getSize() == 0) {
                resp.sendRedirect(req.getContextPath() + "/admin/songs?msg=no_file");
                return;
            }
            if (part.getSize() > 5 * 1024 * 1024) {
                resp.sendRedirect(req.getContextPath() + "/admin/songs?msg=too_large");
                return;
            }

            BufferedImage src = ImageIO.read(part.getInputStream());
            if (src == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/songs?msg=invalid_image");
                return;
            }

            // Fit into 1280×720 (16:9) for OG + video placeholder
            BufferedImage dst = fitCover(src, 1280, 720);

            File dir = SongPreviewFileServlet.previewDir(getServletContext());
            if (!dir.exists()) {
                dir.mkdirs();
            }
            String filename = songId + ".jpg";
            File outFile = new File(dir, filename);
            writeJpeg(dst, outFile);

            String relUrl = req.getContextPath() + "/uploads/song-previews/" + filename;
            // Bust caches after replace
            relUrl = relUrl + "?v=" + outFile.lastModified();
            songs.updatePreviewImageUrl(songId, relUrl);
            resp.sendRedirect(req.getContextPath() + "/admin/songs?msg=preview_saved");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void deletePreview(int songId) throws SQLException, IOException {
        String old = songs.getPreviewImageUrl(songId);
        songs.updatePreviewImageUrl(songId, null);
        File dir = SongPreviewFileServlet.previewDir(getServletContext());
        File file = new File(dir, songId + ".jpg");
        if (file.isFile()) {
            Files.deleteIfExists(file.toPath());
        }
        // also try stripping query from stored URL
        if (old != null) {
            String name = old.replaceFirst("^.*/", "").replaceFirst("\\?.*$", "");
            if (name.matches("[A-Za-z0-9_-]+\\.(jpg|jpeg|png|webp)")) {
                Files.deleteIfExists(new File(dir, name).toPath());
            }
        }
    }

    /** Scale + center-crop into target aspect ratio. */
    static BufferedImage fitCover(BufferedImage src, int tw, int th) {
        double scale = Math.max((double) tw / src.getWidth(), (double) th / src.getHeight());
        int sw = (int) Math.round(src.getWidth() * scale);
        int sh = (int) Math.round(src.getHeight() * scale);
        BufferedImage scaled = new BufferedImage(sw, sh, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = scaled.createGraphics();
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g.drawImage(src, 0, 0, sw, sh, null);
        g.dispose();

        int x = Math.max(0, (sw - tw) / 2);
        int y = Math.max(0, (sh - th) / 2);
        BufferedImage out = new BufferedImage(tw, th, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2 = out.createGraphics();
        g2.drawImage(scaled, 0, 0, tw, th, x, y, x + tw, y + th, null);
        g2.dispose();
        return out;
    }

    private static void writeJpeg(BufferedImage img, File outFile) throws IOException {
        Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName("jpeg");
        if (!writers.hasNext()) {
            ImageIO.write(img, "jpg", outFile);
            return;
        }
        ImageWriter writer = writers.next();
        ImageWriteParam param = writer.getDefaultWriteParam();
        if (param.canWriteCompressed()) {
            param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
            param.setCompressionQuality(0.88f);
        }
        try (FileImageOutputStream fos = new FileImageOutputStream(outFile)) {
            writer.setOutput(fos);
            writer.write(null, new IIOImage(img, null, null), param);
            writer.dispose();
        }
    }
}

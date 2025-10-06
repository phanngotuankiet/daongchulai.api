import express from 'express';
import { generateUploadUrl, deleteFile, extractS3Key } from '../services/s3Service';

const router = express.Router();

// Generate presigned URL for image upload
router.post('/generate-upload-url', async (req, res) => {
  try {
    const { fileName, fileType } = req.body;

    if (!fileName || !fileType) {
      return res.status(400).json({
        message: 'Missing fileName or fileType'
      });
    }

    // Validate file type
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
    if (!allowedTypes.includes(fileType)) {
      return res.status(400).json({
        message: 'Invalid file type. Only images are allowed.'
      });
    }

    const { uploadUrl, fileUrl, key } = await generateUploadUrl(fileName, fileType);

    res.json({
      uploadUrl,
      fileUrl,
      key
    });

  } catch (error) {
    console.error('Error generating upload URL:', error);
    res.status(500).json({
      message: 'Internal server error'
    });
  }
});

// Delete image from S3
router.delete('/delete-image', async (req, res) => {
  try {
    const { imageUrl } = req.body;

    if (!imageUrl) {
      return res.status(400).json({
        message: 'Missing imageUrl'
      });
    }

    const key = extractS3Key(imageUrl);
    if (!key) {
      return res.status(400).json({
        message: 'Invalid S3 URL'
      });
    }

    await deleteFile(key);

    res.json({
      message: 'Image deleted successfully'
    });

  } catch (error) {
    console.error('Error deleting image:', error);
    res.status(500).json({
      message: 'Internal server error'
    });
  }
});

export default router;

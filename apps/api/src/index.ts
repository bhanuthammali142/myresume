import express from 'express';
import cors from 'cors';
import { getUserProfileHandler } from './user';

const app = express();
app.use(cors());
app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'ResumeAI API' });
});

app.get('/user', getUserProfileHandler);

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`API server running on port ${PORT}`);
});

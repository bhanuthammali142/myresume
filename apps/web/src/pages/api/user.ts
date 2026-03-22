import { NextApiRequest, NextApiResponse } from 'next';
import { getUserProfile } from 'db/src/user';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }
  const { userId } = req.query;
  if (!userId || typeof userId !== 'string') {
    return res.status(400).json({ error: 'Missing userId' });
  }
  try {
    const profile = await getUserProfile(userId);
    res.status(200).json(profile);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
}

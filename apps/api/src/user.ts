import { supabaseAdmin } from './supabaseAdmin';
import { Request, Response } from 'express';

export async function getUserProfileHandler(req: Request, res: Response) {
  const { userId } = req.query;
  if (!userId || typeof userId !== 'string') {
    return res.status(400).json({ error: 'Missing userId' });
  }
  const { data, error } = await supabaseAdmin
    .from('users')
    .select('*')
    .eq('id', userId)
    .single();
  if (error) return res.status(500).json({ error: error.message });
  res.status(200).json(data);
}

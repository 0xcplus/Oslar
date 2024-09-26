// /api/getApiKey.js
export default function handler(req, res) {
  const apiKey = process.env.OPEN_AI_API_KEY;
  res.status(200).json({ apiKey });
}
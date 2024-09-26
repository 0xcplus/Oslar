export default function handler(req, res) {
  const apiKey = process.env.OPEN_AI_API_KEY; // 환경 변수에서 API 키 가져오기

  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Credentials', 'true');
  res.setHeader('Access-Control-Allow-Origin', 'https://0xcplus.github.io');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version');

  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end(); // OPTIONS 요청에 대한 응답
    return;
  }

  // GET 요청 처리
  if (req.method === 'GET') {
    res.status(200).json({ apiKey });
  } else {
    res.status(405).end(); // 허용되지 않은 메서드에 대한 405 응답
  }
}
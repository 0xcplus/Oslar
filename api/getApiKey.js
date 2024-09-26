export default function handler(req, res) {
  const apiKey = process.env.YOUR_API_KEY; // 환경 변수에서 API 키 가져오기

  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', 'https://0xcplus.github.io'); // 특정 출처 허용
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Access-Control-Allow-Credentials', 'true');

  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end(); // OPTIONS 요청에 대한 응답
    return;
  }

  // GET 요청 처리
  if (req.method === 'GET') {
    res.status(200).json({ apiKey }); // API 키를 반환
  } else {
    res.status(405).end(); // 허용되지 않은 메서드에 대한 405 응답
  }
}
export default function handler(req, res) {
  const userAgent = req.headers['user-agent'] || '';

  if (userAgent.includes('Roblox') || userAgent.includes('Synapse')) {
    // ✅ Allow script execution from executor
    res.setHeader('Content-Type', 'text/plain');
    res.send(`-- your Lua script here`);
  } else {
    // ❌ Block browser access
    res.status(403).send('403 Forbidden - You are not allowed to view this script directly.');
  }
}

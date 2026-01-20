export default function Home() {
  return (
    <main style={{ padding: '2rem', fontFamily: 'system-ui' }}>
      <h1>Notes API</h1>
      <p>Workshop demo for AWS ECS deployment</p>
      <h2>Endpoints</h2>
      <ul>
        <li><code>GET /api/notes</code> - List all notes</li>
        <li><code>GET /api/notes/:id</code> - Get a note</li>
        <li><code>POST /api/notes</code> - Create a note</li>
        <li><code>PUT /api/notes/:id</code> - Update a note</li>
        <li><code>DELETE /api/notes/:id</code> - Delete a note</li>
        <li><code>GET /api/health</code> - Health check</li>
      </ul>
    </main>
  );
}

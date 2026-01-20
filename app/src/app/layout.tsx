import './globals.css';

export const metadata = {
  title: 'Notes App',
  description: 'Workshop demo for AWS ECS deployment',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <header style={{
          background: 'linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%)',
          color: 'white',
          padding: '1.5rem 2rem',
          boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
        }}>
          <div style={{ maxWidth: '800px', margin: '0 auto' }}>
            <h1 style={{ fontSize: '1.75rem', fontWeight: 600 }}>Notes App</h1>
            <p style={{ opacity: 0.9, marginTop: '0.25rem', fontSize: '0.9rem' }}>
              AWS ECS Workshop Demo
            </p>
          </div>
        </header>

        <main style={{ flex: 1, padding: '2rem', maxWidth: '800px', margin: '0 auto', width: '100%' }}>
          {children}
        </main>

        <footer style={{
          background: 'var(--card-bg)',
          borderTop: '1px solid var(--border)',
          padding: '1.5rem 2rem',
          textAlign: 'center',
          color: 'var(--text-muted)',
          fontSize: '0.875rem',
        }}>
          <p>Built with Next.js, Drizzle ORM, and AWS ECS Fargate</p>
          <p style={{ marginTop: '0.5rem' }}>
            <a href="/api/health" target="_blank">Health Check</a>
            {' | '}
            <a href="https://github.com/DanyloMaryskevych/NotesAPI" target="_blank" rel="noopener">GitHub</a>
          </p>
        </footer>
      </body>
    </html>
  );
}

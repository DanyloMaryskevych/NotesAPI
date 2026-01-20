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
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
      </head>
      <body>
        <header style={{
          background: 'var(--bg-secondary)',
          borderBottom: '1px solid var(--border)',
          position: 'sticky',
          top: 0,
          zIndex: 100,
          backdropFilter: 'blur(12px)',
        }}>
          <div style={{
            maxWidth: '900px',
            margin: '0 auto',
            padding: '1rem 2rem',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
              <div style={{
                width: '40px',
                height: '40px',
                background: 'var(--gradient)',
                borderRadius: '10px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '1.25rem',
                boxShadow: '0 4px 12px rgba(99, 102, 241, 0.4)',
              }}>
                📝
              </div>
              <div>
                <h1 style={{ fontSize: '1.25rem', fontWeight: 700, letterSpacing: '-0.02em' }}>
                  Notes
                </h1>
                <p style={{ fontSize: '0.75rem', color: 'var(--text-dim)', marginTop: '-2px' }}>
                  AWS ECS Workshop
                </p>
              </div>
            </div>
            <nav style={{ display: 'flex', gap: '1.5rem', alignItems: 'center' }}>
              <a
                href="/api/health"
                target="_blank"
                style={{
                  fontSize: '0.875rem',
                  color: 'var(--text-muted)',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.375rem',
                  transition: 'color 0.2s',
                }}
              >
                <span style={{
                  width: '8px',
                  height: '8px',
                  background: '#10b981',
                  borderRadius: '50%',
                  boxShadow: '0 0 8px #10b981',
                }} />
                Healthy
              </a>
              <a
                href="https://github.com/DanyloMaryskevych/NotesAPI"
                target="_blank"
                rel="noopener"
                style={{
                  fontSize: '0.875rem',
                  color: 'var(--text-muted)',
                  transition: 'color 0.2s',
                }}
              >
                GitHub →
              </a>
            </nav>
          </div>
        </header>

        <main style={{
          flex: 1,
          padding: '2.5rem 2rem',
          maxWidth: '900px',
          margin: '0 auto',
          width: '100%',
        }}>
          {children}
        </main>

        <footer style={{
          background: 'var(--bg-secondary)',
          borderTop: '1px solid var(--border)',
          padding: '2rem',
        }}>
          <div style={{
            maxWidth: '900px',
            margin: '0 auto',
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            flexWrap: 'wrap',
            gap: '1rem',
          }}>
            <div style={{ color: 'var(--text-dim)', fontSize: '0.875rem' }}>
              <span style={{ fontWeight: 500 }}>Notes App</span>
              <span style={{ margin: '0 0.5rem' }}>·</span>
              Built for AWS ECS Workshop
            </div>
            <div style={{
              display: 'flex',
              gap: '2rem',
              fontSize: '0.875rem',
              color: 'var(--text-dim)',
            }}>
              <span>Next.js</span>
              <span>Drizzle ORM</span>
              <span>PostgreSQL</span>
              <span>ECS Fargate</span>
            </div>
          </div>
        </footer>
      </body>
    </html>
  );
}

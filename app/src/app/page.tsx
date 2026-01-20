'use client';

import { useState, useEffect, CSSProperties } from 'react';

interface Note {
  id: string;
  title: string;
  content: string | null;
  createdAt: string;
  updatedAt: string;
}

export default function Home() {
  const [notes, setNotes] = useState<Note[]>([]);
  const [loading, setLoading] = useState(true);
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [editingId, setEditingId] = useState<string | null>(null);
  const [error, setError] = useState('');
  const [saving, setSaving] = useState(false);
  const [deletingId, setDeletingId] = useState<string | null>(null);

  const fetchNotes = async () => {
    try {
      const res = await fetch('/api/notes');
      const data = await res.json();
      setNotes(data);
    } catch {
      setError('Failed to fetch notes');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchNotes();
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim() || saving) return;

    setSaving(true);
    try {
      if (editingId) {
        await fetch(`/api/notes/${editingId}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ title, content }),
        });
      } else {
        await fetch('/api/notes', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ title, content }),
        });
      }
      setTitle('');
      setContent('');
      setEditingId(null);
      fetchNotes();
    } catch {
      setError('Failed to save note');
    } finally {
      setSaving(false);
    }
  };

  const handleEdit = (note: Note) => {
    setEditingId(note.id);
    setTitle(note.title);
    setContent(note.content || '');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Delete this note?')) return;

    setDeletingId(id);
    try {
      await fetch(`/api/notes/${id}`, { method: 'DELETE' });
      fetchNotes();
    } catch {
      setError('Failed to delete note');
    } finally {
      setDeletingId(null);
    }
  };

  const handleCancel = () => {
    setEditingId(null);
    setTitle('');
    setContent('');
  };

  const formatDate = (dateStr: string) => {
    const date = new Date(dateStr);
    const now = new Date();
    const diff = now.getTime() - date.getTime();
    const minutes = Math.floor(diff / 60000);
    const hours = Math.floor(diff / 3600000);
    const days = Math.floor(diff / 86400000);

    if (minutes < 1) return 'Just now';
    if (minutes < 60) return `${minutes}m ago`;
    if (hours < 24) return `${hours}h ago`;
    if (days < 7) return `${days}d ago`;
    return date.toLocaleDateString();
  };

  const styles: Record<string, CSSProperties> = {
    card: {
      background: 'var(--card-bg)',
      borderRadius: '16px',
      border: '1px solid var(--border)',
      padding: '1.5rem',
      boxShadow: 'var(--shadow)',
      transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
    },
    input: {
      width: '100%',
      padding: '0.875rem 1rem',
      borderRadius: '10px',
      border: '2px solid var(--border)',
      background: 'var(--input-bg)',
      color: 'var(--text)',
      fontSize: '1rem',
      transition: 'all 0.2s ease',
      outline: 'none',
    },
    button: {
      padding: '0.75rem 1.5rem',
      borderRadius: '10px',
      border: 'none',
      cursor: 'pointer',
      fontSize: '0.9rem',
      fontWeight: 600,
      transition: 'all 0.2s cubic-bezier(0.4, 0, 0.2, 1)',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      gap: '0.5rem',
    },
    primaryButton: {
      background: 'var(--gradient)',
      color: 'white',
      boxShadow: '0 4px 14px rgba(99, 102, 241, 0.4)',
    },
    secondaryButton: {
      background: 'var(--border)',
      color: 'var(--text)',
    },
    dangerButton: {
      background: 'transparent',
      color: 'var(--danger)',
      border: '1px solid var(--danger)',
    },
    iconButton: {
      padding: '0.5rem',
      borderRadius: '8px',
      border: 'none',
      cursor: 'pointer',
      background: 'transparent',
      color: 'var(--text-muted)',
      transition: 'all 0.2s ease',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
    },
  };

  return (
    <div>
      {error && (
        <div
          style={{
            background: 'rgba(239, 68, 68, 0.1)',
            border: '1px solid rgba(239, 68, 68, 0.3)',
            color: '#f87171',
            padding: '1rem 1.25rem',
            borderRadius: '12px',
            marginBottom: '1.5rem',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            animation: 'fadeIn 0.3s ease-out',
          }}
        >
          <span>⚠️ {error}</span>
          <button
            onClick={() => setError('')}
            style={{ ...styles.iconButton, color: '#f87171' }}
          >
            ✕
          </button>
        </div>
      )}

      {/* Form Card */}
      <div
        style={{
          ...styles.card,
          marginBottom: '2.5rem',
          background: editingId
            ? 'linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(139, 92, 246, 0.05) 100%)'
            : 'var(--card-bg)',
          borderColor: editingId ? 'rgba(99, 102, 241, 0.3)' : 'var(--border)',
        }}
      >
        <div style={{ marginBottom: '1.25rem' }}>
          <h2 style={{
            fontSize: '1.25rem',
            fontWeight: 600,
            display: 'flex',
            alignItems: 'center',
            gap: '0.5rem',
          }}>
            {editingId ? '✏️ Edit Note' : '✨ Create Note'}
          </h2>
          <p style={{ color: 'var(--text-dim)', fontSize: '0.875rem', marginTop: '0.25rem' }}>
            {editingId ? 'Update your note below' : 'Add a new note to your collection'}
          </p>
        </div>

        <form onSubmit={handleSubmit}>
          <input
            type="text"
            placeholder="What's on your mind?"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            style={{
              ...styles.input,
              marginBottom: '0.75rem',
              fontWeight: 500,
            }}
            onFocus={(e) => {
              e.target.style.borderColor = 'var(--primary)';
              e.target.style.boxShadow = '0 0 0 3px rgba(99, 102, 241, 0.2)';
            }}
            onBlur={(e) => {
              e.target.style.borderColor = 'var(--border)';
              e.target.style.boxShadow = 'none';
            }}
          />
          <textarea
            placeholder="Add some details... (optional)"
            value={content}
            onChange={(e) => setContent(e.target.value)}
            rows={4}
            style={{
              ...styles.input,
              marginBottom: '1.25rem',
              resize: 'vertical',
              minHeight: '100px',
            }}
            onFocus={(e) => {
              e.target.style.borderColor = 'var(--primary)';
              e.target.style.boxShadow = '0 0 0 3px rgba(99, 102, 241, 0.2)';
            }}
            onBlur={(e) => {
              e.target.style.borderColor = 'var(--border)';
              e.target.style.boxShadow = 'none';
            }}
          />
          <div style={{ display: 'flex', gap: '0.75rem' }}>
            <button
              type="submit"
              disabled={saving || !title.trim()}
              style={{
                ...styles.button,
                ...styles.primaryButton,
                opacity: saving || !title.trim() ? 0.6 : 1,
                cursor: saving || !title.trim() ? 'not-allowed' : 'pointer',
              }}
              onMouseOver={(e) => {
                if (!saving && title.trim()) {
                  e.currentTarget.style.transform = 'translateY(-2px)';
                  e.currentTarget.style.boxShadow = '0 6px 20px rgba(99, 102, 241, 0.5)';
                }
              }}
              onMouseOut={(e) => {
                e.currentTarget.style.transform = 'translateY(0)';
                e.currentTarget.style.boxShadow = '0 4px 14px rgba(99, 102, 241, 0.4)';
              }}
            >
              {saving ? (
                <>
                  <span style={{ animation: 'pulse 1s infinite' }}>⏳</span>
                  Saving...
                </>
              ) : editingId ? (
                <>💾 Update Note</>
              ) : (
                <>➕ Add Note</>
              )}
            </button>
            {editingId && (
              <button
                type="button"
                onClick={handleCancel}
                style={{ ...styles.button, ...styles.secondaryButton }}
                onMouseOver={(e) => {
                  e.currentTarget.style.background = 'var(--card-hover)';
                }}
                onMouseOut={(e) => {
                  e.currentTarget.style.background = 'var(--border)';
                }}
              >
                Cancel
              </button>
            )}
          </div>
        </form>
      </div>

      {/* Notes Section */}
      <div style={{ marginBottom: '1.5rem', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <h2 style={{ fontSize: '1.25rem', fontWeight: 600 }}>
          📚 Your Notes
          {!loading && (
            <span style={{
              marginLeft: '0.75rem',
              fontSize: '0.875rem',
              color: 'var(--text-dim)',
              fontWeight: 400,
            }}>
              {notes.length} {notes.length === 1 ? 'note' : 'notes'}
            </span>
          )}
        </h2>
      </div>

      {loading ? (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
          {[1, 2, 3].map((i) => (
            <div
              key={i}
              style={{
                ...styles.card,
                background: 'linear-gradient(90deg, var(--card-bg) 25%, var(--card-hover) 50%, var(--card-bg) 75%)',
                backgroundSize: '200% 100%',
                animation: 'shimmer 1.5s infinite',
                height: '120px',
              }}
            />
          ))}
        </div>
      ) : notes.length === 0 ? (
        <div
          style={{
            ...styles.card,
            textAlign: 'center',
            padding: '3rem 2rem',
          }}
        >
          <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>📝</div>
          <h3 style={{ fontSize: '1.125rem', marginBottom: '0.5rem' }}>No notes yet</h3>
          <p style={{ color: 'var(--text-dim)' }}>Create your first note above to get started!</p>
        </div>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
          {notes.map((note, index) => (
            <div
              key={note.id}
              style={{
                ...styles.card,
                animation: `fadeIn 0.4s ease-out ${index * 0.05}s both`,
                cursor: 'default',
              }}
              onMouseOver={(e) => {
                e.currentTarget.style.borderColor = 'var(--primary)';
                e.currentTarget.style.transform = 'translateY(-2px)';
                e.currentTarget.style.boxShadow = 'var(--shadow-lg)';
              }}
              onMouseOut={(e) => {
                e.currentTarget.style.borderColor = 'var(--border)';
                e.currentTarget.style.transform = 'translateY(0)';
                e.currentTarget.style.boxShadow = 'var(--shadow)';
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: '1rem' }}>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <h3 style={{
                    fontSize: '1.1rem',
                    fontWeight: 600,
                    marginBottom: '0.5rem',
                    color: 'var(--text)',
                  }}>
                    {note.title}
                  </h3>
                  {note.content && (
                    <p style={{
                      color: 'var(--text-muted)',
                      marginBottom: '0.75rem',
                      whiteSpace: 'pre-wrap',
                      lineHeight: 1.6,
                    }}>
                      {note.content}
                    </p>
                  )}
                  <div style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '0.5rem',
                    fontSize: '0.75rem',
                    color: 'var(--text-dim)',
                  }}>
                    <span>🕐</span>
                    {formatDate(note.createdAt)}
                  </div>
                </div>
                <div style={{ display: 'flex', gap: '0.5rem', flexShrink: 0 }}>
                  <button
                    onClick={() => handleEdit(note)}
                    style={{
                      ...styles.button,
                      ...styles.secondaryButton,
                      padding: '0.5rem 1rem',
                      fontSize: '0.8rem',
                    }}
                    onMouseOver={(e) => {
                      e.currentTarget.style.background = 'var(--primary)';
                      e.currentTarget.style.color = 'white';
                    }}
                    onMouseOut={(e) => {
                      e.currentTarget.style.background = 'var(--border)';
                      e.currentTarget.style.color = 'var(--text)';
                    }}
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDelete(note.id)}
                    disabled={deletingId === note.id}
                    style={{
                      ...styles.button,
                      ...styles.dangerButton,
                      padding: '0.5rem 1rem',
                      fontSize: '0.8rem',
                      opacity: deletingId === note.id ? 0.5 : 1,
                    }}
                    onMouseOver={(e) => {
                      if (deletingId !== note.id) {
                        e.currentTarget.style.background = 'var(--danger)';
                        e.currentTarget.style.color = 'white';
                        e.currentTarget.style.borderColor = 'var(--danger)';
                      }
                    }}
                    onMouseOut={(e) => {
                      e.currentTarget.style.background = 'transparent';
                      e.currentTarget.style.color = 'var(--danger)';
                      e.currentTarget.style.borderColor = 'var(--danger)';
                    }}
                  >
                    {deletingId === note.id ? '...' : 'Delete'}
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

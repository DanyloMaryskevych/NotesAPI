'use client';

import { useState, useEffect } from 'react';

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

  const fetchNotes = async () => {
    try {
      const res = await fetch('/api/notes');
      const data = await res.json();
      setNotes(data);
    } catch (err) {
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
    if (!title.trim()) return;

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
    } catch (err) {
      setError('Failed to save note');
    }
  };

  const handleEdit = (note: Note) => {
    setEditingId(note.id);
    setTitle(note.title);
    setContent(note.content || '');
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this note?')) return;

    try {
      await fetch(`/api/notes/${id}`, { method: 'DELETE' });
      fetchNotes();
    } catch (err) {
      setError('Failed to delete note');
    }
  };

  const handleCancel = () => {
    setEditingId(null);
    setTitle('');
    setContent('');
  };

  const buttonStyle = {
    padding: '0.5rem 1rem',
    borderRadius: '6px',
    border: 'none',
    cursor: 'pointer',
    fontSize: '0.875rem',
    fontWeight: 500,
    transition: 'background 0.2s',
  };

  const primaryButton = {
    ...buttonStyle,
    background: 'var(--primary)',
    color: 'white',
  };

  const secondaryButton = {
    ...buttonStyle,
    background: 'var(--border)',
    color: 'var(--text)',
  };

  const dangerButton = {
    ...buttonStyle,
    background: 'var(--danger)',
    color: 'white',
  };

  return (
    <div>
      {error && (
        <div style={{
          background: '#fef2f2',
          border: '1px solid #fecaca',
          color: '#dc2626',
          padding: '0.75rem 1rem',
          borderRadius: '8px',
          marginBottom: '1.5rem',
        }}>
          {error}
          <button onClick={() => setError('')} style={{ float: 'right', background: 'none', border: 'none', cursor: 'pointer' }}>x</button>
        </div>
      )}

      <div style={{
        background: 'var(--card-bg)',
        borderRadius: '12px',
        padding: '1.5rem',
        boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
        marginBottom: '2rem',
      }}>
        <h2 style={{ fontSize: '1.25rem', marginBottom: '1rem' }}>
          {editingId ? 'Edit Note' : 'Add New Note'}
        </h2>
        <form onSubmit={handleSubmit}>
          <input
            type="text"
            placeholder="Note title"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            style={{
              width: '100%',
              padding: '0.75rem',
              borderRadius: '6px',
              border: '1px solid var(--border)',
              marginBottom: '0.75rem',
              fontSize: '1rem',
            }}
          />
          <textarea
            placeholder="Note content (optional)"
            value={content}
            onChange={(e) => setContent(e.target.value)}
            rows={3}
            style={{
              width: '100%',
              padding: '0.75rem',
              borderRadius: '6px',
              border: '1px solid var(--border)',
              marginBottom: '1rem',
              fontSize: '1rem',
              resize: 'vertical',
            }}
          />
          <div style={{ display: 'flex', gap: '0.5rem' }}>
            <button type="submit" style={primaryButton}>
              {editingId ? 'Update Note' : 'Add Note'}
            </button>
            {editingId && (
              <button type="button" onClick={handleCancel} style={secondaryButton}>
                Cancel
              </button>
            )}
          </div>
        </form>
      </div>

      <h2 style={{ fontSize: '1.25rem', marginBottom: '1rem' }}>
        Your Notes {!loading && `(${notes.length})`}
      </h2>

      {loading ? (
        <p style={{ color: 'var(--text-muted)' }}>Loading notes...</p>
      ) : notes.length === 0 ? (
        <div style={{
          background: 'var(--card-bg)',
          borderRadius: '12px',
          padding: '2rem',
          textAlign: 'center',
          color: 'var(--text-muted)',
        }}>
          No notes yet. Create your first note above!
        </div>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
          {notes.map((note) => (
            <div
              key={note.id}
              style={{
                background: 'var(--card-bg)',
                borderRadius: '12px',
                padding: '1.25rem',
                boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                <div style={{ flex: 1 }}>
                  <h3 style={{ fontSize: '1.1rem', marginBottom: '0.5rem' }}>{note.title}</h3>
                  {note.content && (
                    <p style={{ color: 'var(--text-muted)', marginBottom: '0.75rem', whiteSpace: 'pre-wrap' }}>
                      {note.content}
                    </p>
                  )}
                  <p style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                    Created: {new Date(note.createdAt).toLocaleString()}
                  </p>
                </div>
                <div style={{ display: 'flex', gap: '0.5rem', marginLeft: '1rem' }}>
                  <button onClick={() => handleEdit(note)} style={secondaryButton}>
                    Edit
                  </button>
                  <button onClick={() => handleDelete(note.id)} style={dangerButton}>
                    Delete
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

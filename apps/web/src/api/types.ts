export type DiaryPhoto = {
  id: string;
  filename: string;
  byte_size: number;
  content_type: string;
  url: string | null;
};

export type DiaryEntry = {
  id: number;
  title: string;
  body: string;
  ai_summary: string | null;
  mood: string | null;
  status: "draft" | "published";
  journal_date: string;
  published_at: string | null;
  labels: string[];
  metadata: Record<string, unknown>;
  extracted_text: string | null;
  tags: string[];
  photos: DiaryPhoto[];
};

export type WeeklyDigest = {
  id: number;
  week_of: string;
  summary: string;
  highlights: Array<Record<string, unknown>>;
  mood_trends: Record<string, number>;
  published_at: string | null;
};

export type ApiMeta = {
  total: number;
  per_page: number;
  page: number;
  total_pages: number;
};

import { Link } from "react-router-dom";
import { useDiaryEntries } from "../hooks/useDiaryEntries";
import { DiaryCard } from "../components/DiaryCard";
import { buttonVariants } from "../components/ui/button";
import { Skeleton } from "../components/ui/skeleton";

export const TimelinePage = () => {
  const { entries, loading, error, loadEntries } = useDiaryEntries();

  return (
    <section className="space-y-6">
      <header className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-semibold">タイムライン</h1>
          <p className="text-sm text-muted-foreground">
            最新の下書きと公開済み記事を確認できます。
          </p>
        </div>
        <Link to="/upload" className={buttonVariants({})}>
          画像を追加
        </Link>
      </header>

      {loading && (
        <div className="space-y-4">
          {[1, 2, 3].map((skeleton) => (
            <Skeleton key={skeleton} className="h-40 w-full" />
          ))}
        </div>
      )}

      {error && (
        <div className="rounded border border-destructive bg-destructive/5 p-4 text-sm text-destructive">
          {error}
        </div>
      )}

      <div className="space-y-4">
        {entries.map((entry) => (
          <DiaryCard key={entry.id} entry={entry} onRefresh={() => loadEntries()} />
        ))}
      </div>
    </section>
  );
};

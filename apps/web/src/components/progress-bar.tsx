import { cn } from "../lib/utils";

export const ProgressBar = ({ value }: { value: number }) => (
  <div className="mt-2 h-2 w-full rounded-full bg-muted">
    <div
      className={cn("h-full rounded-full bg-primary transition-all")}
      style={{ width: `${value}%` }}
    />
  </div>
);

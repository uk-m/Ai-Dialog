import * as React from "react";
import { cn } from "../../lib/utils";

type TabsContext = {
  value: string;
  setValue: (value: string) => void;
};

const TabsContext = React.createContext<TabsContext | null>(null);

const Tabs = ({
  defaultValue,
  className,
  children,
}: {
  defaultValue: string;
  className?: string;
  children: React.ReactNode;
}) => {
  const [value, setValue] = React.useState(defaultValue);
  return (
    <TabsContext.Provider value={{ value, setValue }}>
      <div className={className}>{children}</div>
    </TabsContext.Provider>
  );
};

const TabsList = ({ className, children }: React.HTMLAttributes<HTMLDivElement>) => (
  <div className={cn("inline-flex h-10 items-center rounded-md bg-muted p-1", className)}>
    {children}
  </div>
);

const TabsTrigger = ({
  value,
  children,
}: {
  value: string;
  children: React.ReactNode;
}) => {
  const ctx = React.useContext(TabsContext);
  if (!ctx) throw new Error("TabsTrigger must be used within Tabs");
  const isActive = ctx.value === value;
  return (
    <button
      type="button"
      className={cn(
        "inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1 text-sm font-medium transition-all focus-visible:outline-none",
        isActive ? "bg-background shadow text-foreground" : "text-muted-foreground",
      )}
      onClick={() => ctx.setValue(value)}
    >
      {children}
    </button>
  );
};

const TabsContent = ({
  value,
  children,
  className,
}: {
  value: string;
  children: React.ReactNode;
  className?: string;
}) => {
  const ctx = React.useContext(TabsContext);
  if (!ctx) throw new Error("TabsContent must be used within Tabs");
  if (ctx.value !== value) return null;
  return <div className={cn("mt-4", className)}>{children}</div>;
};

export { Tabs, TabsList, TabsTrigger, TabsContent };

-- Clean re-run script for Double D Portal tables
-- Safe to run even if some objects already exist

-- Drop existing policies if they exist
drop policy if exists "Allow all for beta" on customers;
drop policy if exists "Allow all for beta" on proposals;
drop policy if exists "Allow all for beta" on memberships;
drop policy if exists "Allow all for beta" on measurement_reports;

-- Tables (safe if they already exist)
create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  name text,
  email text,
  phone text,
  address text,
  created_at timestamptz default now()
);

create table if not exists proposals (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references customers(id),
  job_type text,
  description text,
  subtotal numeric,
  is_commercial boolean default false,
  tax_amount numeric default 0,
  total numeric,
  status text default 'pending',
  created_at timestamptz default now()
);

create table if not exists memberships (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references customers(id),
  tier text,
  squares numeric,
  pitch_multiplier numeric default 1,
  annual_price numeric,
  visits_remaining int,
  next_visit date,
  expires_on date,
  status text default 'active',
  created_at timestamptz default now()
);

create table if not exists measurement_reports (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references customers(id),
  source text,
  squares numeric,
  pitch text,
  notes text,
  created_at timestamptz default now()
);

-- Enable RLS
alter table customers enable row level security;
alter table proposals enable row level security;
alter table memberships enable row level security;
alter table measurement_reports enable row level security;

-- Recreate open policies for beta
create policy "Allow all for beta" on customers for all using (true) with check (true);
create policy "Allow all for beta" on proposals for all using (true) with check (true);
create policy "Allow all for beta" on memberships for all using (true) with check (true);
create policy "Allow all for beta" on measurement_reports for all using (true) with check (true);

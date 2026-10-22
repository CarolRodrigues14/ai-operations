-- Tabela de pedidos de reembolso (AI Operations)
-- Rodar no SQL Editor do Supabase.

create table public.reembolsos (
  id uuid primary key default gen_random_uuid(),
  criado_em timestamptz not null default now(),

  -- dados do formulário (Tally)
  nome_funcionario text not null,
  contato_funcionario text,
  categoria text,
  descricao text,
  valor_declarado numeric(10,2) not null,
  comprovante_url text,

  -- IA 1: OCR do comprovante
  valor_comprovante numeric(10,2),
  data_comprovante date,
  estabelecimento text,
  legibilidade text,
  divergencia boolean,

  -- IA 2: análise de risco
  risco_ia text check (risco_ia in ('baixo', 'alto')),
  justificativa_ia text,
  sinais_ia jsonb,

  -- decisão e trilha de auditoria
  status text not null default 'em_analise'
    check (status in ('em_analise', 'aprovado', 'rejeitado', 'revisao_humana')),
  tipo_decisao text check (tipo_decisao in ('automatica', 'humana')),
  aprovado_por text,
  data_decisao timestamptz,
  erro_processamento text
);

-- RLS ligado e sem políticas: nenhum acesso pela API pública.
-- O n8n acessa com a chave de serviço (server-side).
alter table public.reembolsos enable row level security;
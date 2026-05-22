-- Altera a tabela profiles para adicionar os campos da Issue #3 que o Supabase Auth não gerencia nativamente
ALTER TABLE public.profiles 
ADD COLUMN phone VARCHAR(20),
ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now());

-- Comentário técnico explicativo para o banco de dados (boas práticas de engenharia)
COMMENT ON COLUMN public.profiles.phone IS 'Campo opcional adicionado para cumprir os requisitos da Issue #3';
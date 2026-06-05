-- 1. CRIAÇÃO DA TABELA PROFILES (Coloque isso no início de tudo)
CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()

    CREATE POLICY "Usuários podem criar o próprio perfil"
ON public.profiles
FOR INSERT
WITH CHECK (auth.uid() = id);
);

-- Habilitar RLS para o profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuários podem criar o próprio perfil"
ON public.profiles
FOR INSERT
WITH CHECK (auth.uid() = id);

CREATE POLICY "Perfis públicos são visíveis para todos" 
ON public.profiles FOR SELECT USING (true);

CREATE POLICY "Usuários podem atualizar o próprio perfil" 
ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- criada a tabela
CREATE TABLE public.contractors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) NOT NULL,
    company_name VARCHAR(255),
    document VARCHAR(20) -- Tamanho suficiente para acomodar CPF ou CNPJ formatado
);

-- Habilitar RLS (Row Level Security) para proteção dos dados conforme requisito
ALTER TABLE public.contractors ENABLE ROW LEVEL SECURITY;

-- As políticas lá de segurança
-- Qualquer utilizador autenticado ou público pode ver o perfil da empresa (útil para os profissionais)
CREATE POLICY "Contratantes visíveis para todos" 
ON public.contractors FOR SELECT 
USING (true);

-- Apenas o próprio utilizador (dono do perfil) pode atualizar os dados da sua empresa
CREATE POLICY "Apenas o próprio contratante pode atualizar" 
ON public.contractors FOR UPDATE 
USING (auth.uid() = user_id);

-- Apenas o próprio utilizador pode criar o seu registo como contratante
CREATE POLICY "Utilizador pode criar o seu registo de contratante" 
ON public.contractors FOR INSERT 
WITH CHECK (auth.uid() = user_id);
-- criada tabela de profissionais, com correção dos erros de digitação
CREATE TABLE public.professionals (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    bio TEXT,
    category VARCHAR(255),
    experience_years INT,
    city VARCHAR(255),
    state VARCHAR(255),
    profile_image VARCHAR(1024), -- URL que virá do Supabase Storage
    is_verified BOOLEAN DEFAULT false,
    average_rating DECIMAL(3, 2) DEFAULT 0.00
);

-- Mais uma vez o RLS (Row Level Security)
ALTER TABLE public.professionals ENABLE ROW LEVEL SECURITY;

-- Políticas de segurança (Policies)
-- Qualquer pessoa (clientes e visitantes) pode ver o perfil dos profissionais
CREATE POLICY "Profissionais visíveis para todos" 
ON public.professionals FOR SELECT 
USING (true);

-- Apenas o próprio dono do perfil pode editar os seus dados profissionais
CREATE POLICY "Apenas o próprio profissional pode atualizar" 
ON public.professionals FOR UPDATE 
USING (auth.uid() = user_id);

-- Apenas o próprio usuário pode criar seu registro profissional
CREATE POLICY "Usuário pode criar o seu registro de profissional" 
ON public.professionals FOR INSERT 
WITH CHECK (auth.uid() = user_id);


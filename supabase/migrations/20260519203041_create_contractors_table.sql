-- criada a tabela
CREATE TABLE public.contractors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
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
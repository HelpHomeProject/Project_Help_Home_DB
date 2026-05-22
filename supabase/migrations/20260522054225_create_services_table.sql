-- Criação da tabela de serviços
CREATE TABLE public.services (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    professional_id UUID REFERENCES public.professionals(id) ON DELETE CASCADE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(255)
);

-- RLS (Row Level Security)
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;

-- Políticas de segurança
-- Catálogo público: Qualquer pessoa pode ver os serviços disponíveis
CREATE POLICY "Serviços visíveis para todos" 
ON public.services FOR SELECT 
USING (true);

-- Inserção: O usuário logado só pode inserir um serviço se o professional_id pertencer a ele
CREATE POLICY "Profissionais criam os seus próprios serviços" 
ON public.services FOR INSERT 
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.professionals 
        WHERE public.professionals.id = professional_id 
        AND public.professionals.user_id = auth.uid()
    )
);

-- Edição: O usuário logado só pode atualizar um serviço se for o dono
CREATE POLICY "Apenas o dono pode atualizar o serviço" 
ON public.services FOR UPDATE 
USING (
    EXISTS (
        SELECT 1 FROM public.professionals 
        WHERE public.professionals.id = public.services.professional_id 
        AND public.professionals.user_id = auth.uid()
    )
);

-- Exclusão: O usuário logado só pode deletar o seu próprio serviço
CREATE POLICY "Apenas o dono pode deletar o serviço" 
ON public.services FOR DELETE 
USING (
    EXISTS (
        SELECT 1 FROM public.professionals 
        WHERE public.professionals.id = public.services.professional_id 
        AND public.professionals.user_id = auth.uid()
    )
);
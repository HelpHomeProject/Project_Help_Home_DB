-- Criação da tabela de portfólios
CREATE TABLE public.portfolios (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    professional_id UUID REFERENCES public.professionals(id) ON DELETE CASCADE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    media_url VARCHAR(1024) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Habilitar RLS, mesmo padrão de segurança, aqueles lá de baixo
ALTER TABLE public.portfolios ENABLE ROW LEVEL SECURITY;

-- Políticas de segurança
-- Portfólios são públicos para visualização (necessário para os contratantes verem o trabalho)
CREATE POLICY "Portfólios visíveis para todos" 
ON public.portfolios FOR SELECT 
USING (true);

-- Apenas o profissional dono do portfólio pode alterá-lo
-- Fazemos um JOIN para verificar se o ID de autenticação bate com o dono do perfil profissional
CREATE POLICY "Apenas o dono pode atualizar o portfólio" 
ON public.portfolios FOR UPDATE 
USING (
    EXISTS (
        SELECT 1 FROM public.professionals 
        WHERE public.professionals.id = public.portfolios.professional_id 
        AND public.professionals.user_id = auth.uid()
    )
);
-- 1. Garante a criação da tabela
CREATE TABLE IF NOT EXISTS public.portfolios (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    professional_id UUID REFERENCES public.professionals(id) ON DELETE CASCADE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    media_url VARCHAR(1024) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Habilita a segurança
ALTER TABLE public.portfolios ENABLE ROW LEVEL SECURITY;

-- 3. DROP manual só por garantia total antes de tentar criar
DROP POLICY IF EXISTS "Portfólios visíveis para todos" ON public.portfolios;
DROP POLICY IF EXISTS "Apenas o dono pode atualizar o portfólio" ON public.portfolios;

-- 4. Criação das políticas usando a segurança máxima do 'IF NOT EXISTS'
CREATE POLICY "Portfólios visíveis para todos" 
ON public.portfolios FOR SELECT 
USING (true);

CREATE POLICY "Apenas o dono pode atualizar o portfólio" 
ON public.portfolios FOR UPDATE 
USING (
    EXISTS (
        SELECT 1 FROM public.professionals 
        WHERE public.professionals.id = public.portfolios.professional_id 
        AND public.professionals.user_id = auth.uid()
    )
);
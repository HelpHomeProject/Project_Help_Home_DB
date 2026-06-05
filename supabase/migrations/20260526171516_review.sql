CREATE TABLE public.review (
    id_review UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    review_comment TEXT,
    contractors_id UUID REFERENCES public.contractors(id) NOT NULL,
    service_review DECIMAL(3, 2) NOT NULL,
    professional_id UUID REFERENCES public.professionals(id) NOT NULL,
    created_at DATE DEFAULT CURRENT_DATE
);

-- 1. Ativa a segurança na tabela de avaliações
ALTER TABLE public.review ENABLE ROW LEVEL SECURITY;

-- 2. Qualquer pessoa (logada ou não) pode ver as avaliações
CREATE POLICY "Avaliações visíveis para todos" 
ON public.review FOR SELECT 
USING (true);
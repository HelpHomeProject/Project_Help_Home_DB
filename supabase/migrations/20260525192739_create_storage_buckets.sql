-- Cria o bucket (tipo o G-drive) que vão ficar os arquivos
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- Cria o bucket pras img do portfolio
INSERT INTO storage.buckets (id, name, public)
VALUES ('portfolios', 'portfolios', true)
ON CONFLICT (id) DO NOTHING;

-- Regras de segurança e pras fotos de avatar/perfil
CREATE POLICY "Qualquer pessoa pode visualizar fotos de perfil"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');

CREATE POLICY "Usuários autenticados podem fazer upload de foto de perfil"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'avatars' AND (storage.foldername(name))[1] = auth.uid()::text);

-- aqui são as regras pra portfolio, mesmo sistema do avatar
CREATE POLICY "Qualquer pessoa pode ver imagens dos portfólios"
ON storage.objects FOR SELECT
USING (bucket_id = 'portfolios');

-- IF user profissional? insere foto
CREATE POLICY "Apenas profissionais cadastrados podem inserir mídias de portfólio"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'portfolios' 
    AND EXISTS (
        SELECT 1 FROM public.professionals 
        WHERE public.professionals.user_id = auth.uid()
    )
);
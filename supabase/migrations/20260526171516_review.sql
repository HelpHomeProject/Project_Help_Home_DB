CREATE TABLE public.review (
    id_review UUID PRIMARY KEY,
    review_comment TEXT,
    id_contractors UUID REFERENCES contractors(id),
    service_review DECIMAL(3, 2) DEFAULT 0.00,
    id_professional UUID REFERENCES
);
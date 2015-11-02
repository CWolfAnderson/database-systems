/*
NOTE: you can't underline in .txt files so I put asterisks around primary keys

authors ( *email*, first_name, last_name )
papers ( *id*, title, file_name, contact_author_email, abstract )
    -- TODO: add multiple authors
scores ( *id*, paper_id, reviewer_email, overall_rating, technical_merit_score, readability_score, originality_score, relevance_score, private_review, public_review )
    -- TODO: add multiple reviewer ids
reviewers ( *email*, first_name, last_name, phone, affiliation )
co_reviewers (*id*, paper_id, reviewer_id )
*/
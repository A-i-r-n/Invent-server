json.code (@fund ? 0 : 1)
json.data do
  json.extract! @fund,:id,:avail,:freeze,:credit,:growth
end
-- flatten-tables.lua
-- Converts the resume's 2-column heading tables (company/location,
-- title/dates) into plain single-line paragraphs so ATS parsers read them
-- linearly instead of misinterpreting table cells. Produces ATS-safe DOCX.
-- Usage: pandoc resume.tex --lua-filter=flatten-tables.lua -o resume.docx

local function cell_to_inlines(cell)
  local inlines = {}
  for _, blk in ipairs(cell.contents) do
    if blk.content then
      for _, il in ipairs(blk.content) do
        table.insert(inlines, il)
      end
    end
  end
  return inlines
end

function Table(tbl)
  local out = {}
  local function emit_rows(rows)
    for _, row in ipairs(rows) do
      local line = {}
      for _, cell in ipairs(row.cells) do
        local ils = cell_to_inlines(cell)
        if #ils > 0 then
          if #line > 0 then
            table.insert(line, pandoc.Str("  |  ")) -- pipe separator (no em dash)
          end
          for _, il in ipairs(ils) do table.insert(line, il) end
        end
      end
      if #line > 0 then
        table.insert(out, pandoc.Para(line))
      end
    end
  end
  for _, body in ipairs(tbl.bodies) do
    emit_rows(body.body)
  end
  return out
end

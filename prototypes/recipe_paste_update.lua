
for _, dbl in ipairs({data.raw["furnace"], data.raw["container"], data.raw["infinity-container"], data.raw["cargo-wagon"]}) do for name, entity in pairs(dbl) do
  if entity.name ~= "pneumatic-intake-filtered" then
    if entity.additional_pastable_entities == nil then
      entity.additional_pastable_entities  = {}
    elseif type(entity.additional_pastable_entities) == "string" then
      entity.additional_pastable_entities = {entity.additional_pastable_entities}
    end

    table.insert(entity.additional_pastable_entities, "pneumatic-intake-filtered")
  end
end end


for _, dbl in ipairs({data.raw["furnace"], data.raw["container"], data.raw["infinity-container"], data.raw["cargo-wagon"]}) do
   for name, entity in pairs(dbl) do
   -- Если имя сущности не равно "pneumatic-intake-filtered" И не равно "pneumatic-outtake-filtered"
      if entity.name ~= "pneumatic-intake-filtered" and entity.name ~= "pneumatic-outtake-filtered" then
         if entity.additional_pastable_entities == nil then
            entity.additional_pastable_entities = {}
         elseif type(entity.additional_pastable_entities) == "string" then
            entity.additional_pastable_entities = {entity.additional_pastable_entities}
         end
      
         -- Добавляем оба элемента в список
         table.insert(entity.additional_pastable_entities, "pneumatic-intake-filtered")
         table.insert(entity.additional_pastable_entities, "pneumatic-outtake-filtered")
      end
   end
end

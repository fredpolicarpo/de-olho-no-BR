shp <- readOGR("config/br_unidades_da_federacao", "BRUFE250GC_SIR", stringsAsFactors=FALSE, encoding="UTF-8")

pg <- fread("data/processed/votos_uf_partido.csv", encoding="Latin-1")
pg$uf = factor(pg$uf)
pg$partido = factor(pg$partido)
pg$eleicao = factor(pg$eleicao)

pg <- as.data.frame(pg)

pg = pg %>% filter(partido == "PT" & eleicao == "ELEICOES 1998")

ibge <- fread("config/estadosibge.csv", encoding="Latin-1")

pg <- merge(pg,ibge, by.x = "uf", by.y = "UF")

brasileiropg <- merge(shp,pg, by.x = "CD_GEOCUF", by.y = "Código UF")

proj4string(brasileiropg) <- CRS("+proj=longlat +datum=WGS84 +no_defs")

 brasileiropg %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(brasileiropg$brasileiropg), 
              fillOpacity = 0.8, 
              color = "#BDBDC3", 
              weight = 1, 
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~brasileiropg$brasileiropg,
            title = "Qtde Votos",
            opacity = 1)

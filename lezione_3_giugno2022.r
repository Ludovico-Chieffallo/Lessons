#packages----
install.packages("colorist")
library(colorist)
library(ggplot2)
#Field Sparrow----
#ESEMPIO 1: MAPPARE UNA DISTRIBUZIONE DI SPECIE NEL CICLO ANNUALE

#Qui, utilizziamo dati aggregati sullo stato e sulle tendenze di eBird per Field Sparrow ( Spizella pusilla ) per illustrare una strategia diversa per la creazione di mappe del ciclo annuale,
#che sfrutta i dati di occorrenza continua (piuttosto che i dati categoriali di presenza-assenza) per descrivere dove e quando gli spettatori potrebbero essere in grado di trovare una specie.

#Carichiamo l'esempio usando la funzione data
data("fiespa_occ")
fiespa_occ


#1)Calcoliamo le metriche 
met1<-metrics_pull(fiespa_occ)  #Questa funzione trasforma i valori dello stack raster che descrivono le distribuzioni individuali o le distribuzioni delle specie in valori di intensità standardizzati.

print(met1)
#creiamo la palette
#Utilizzeremo la funzione palette_timecycle() perchè i nostri dati rapprenentano una sequyuenza ordinata e ciclica (tutti i mesi dell'anno)
pal<- palette_timecycle(fiespa_occ)

head(pal)  
#Abbiamo visto come la funzione palette_timecycle ci restituisca un frame di dati con tre campi: specificy layer_id e color
#I campi specificity e layer_id verranno utilizzati per assegnare i colori a celle raster specifiche

map_multiples(met1, pal, ncol = 3, labels = names (fiespa_occ))

#Se vogliamo estrarre un mese di dati per un'analisi più approfondita, possiamo utilizzare map_single()e specificare quale mese di dati vorremmo vedere utilizzando l'argomento layer.
map_single(met1, pal, layer = 6)

# change palette start position on color wheel
p1_custom <- palette_timecycle(12, start_hue = 60)

# map layers with custom
map_multiples(met1, p1_custom, labels = names(fiespa_occ), ncol = 4)

#map distill
met1_distill<-metrics_distill(fiespa_occ)  #"Distilliamo" quindi le informazioni
map_single(met1_distill,pal)               #Visualizziamo quindi le informazione nella singola immagine con le immagini "distillate" e  la palette creata in precedenza

legend_timecycle(pal, origin_label = "jan 1")

# change labels on legend
l_fiespa <- legend_timecycle(pal, 
                             origin_label = "Jan 1",
                             # specificity labels
                             label_s = c("Low\nseasonality", 
                                         "Moderate\nseasonality", 
                                         "High\nseasonality"), 
                             # intensity label
                             label_i = "Peak occurrence", 
                             # layers label
                             label_l = "Month of peak occurrence")


# show legend
print(l_fiespa)
#Pekania pennanti----
#ESEMPIO 2: MAPPARE IL COMPORTAMENTO INDIVIDUALE NEL TEMPO
#Qui esploriamo come un individuo Fisher ( Pekania pennanti ) che vive nello stato di New York si è spostato nel suo ambiente locale per un periodo di nove notti sequenziali nel 2011. 


data("fisher_ud")   
fisher_ud

m2<-metrics_pull(fisher_ud)
m2

pal2<-palette_timeline(fisher_ud)
head(pal2)


map_multiples(m2,ncol = 3, pal2)

map_multiples(m2,ncol = 3, pal2, lambda_i = -5 )


m2_distill<-metrics_distill(fisher_ud)
map_single(m2_distill,pal2,lambda_i = -5)

# visualize metrics in a single map with adjustment to lambda_s
map_single(m2_distill, pal2, lambda_i = -5, lambda_s = 12)

#Ovviamente avendo utilizzato valori lineari, utilizzeremo legend_timeline e non legend_timecycle
legend_timeline(pal2,time_labels = c("2 aprile", "11 aprile"))

#avremo un esempio dettagliato in un altro script


#loxodonta africana----
#Negli esempi precedenti, abbiamo esplorato le distribuzioni di una singola specie e di un singolo individuo in più periodi di tempo. 
#colorist può essere utilizzato anche per esplorare la distribuzione di più specie o individui in un unico periodo di tempo.

#Qui, utilizziamo i dati di tracciamento GPS raccolti dagli elefanti africani ( Loxodonta africana ) nel Parco nazionale di Etosha (Namibia) durante il 2011 per esplorare come due individui hanno utilizzato il paesaggio nel corso di un anno.

#ESEMPIO 3: MAPPARE LE DISTRIBUZIONI DI PIU' INDIVIDUI DURANTE LO STESSO PERIODO DI TEMPO
data("elephant_ud")
elephant_ud


#Estraiamo i dati dal Rasterstack
met3<-metrics_pull((elephant_ud))

pal3<-palette_set(elephant_ud)

map_multiples(met3, pal3, ncol = 2,lambda_i = -5,labels = names(elephant_ud))

#change name and opacity
map_multiples(met3, pal3, labels = c("'uno'", "'due'"), ncol = 2)
# use custom_hues argument to make specific hue choices
p3_custom <- palette_set(2, custom_hues = c(280, 120))

# map layers
map_multiples(met3, p3_custom, labels = c("'uno'", "'due'"), ncol = 2,lambda_i = -12)


met3_distt<-metrics_distill(elephant_ud)
map_single(met3_distt,pal2,lambda_i = -5)

#Qui utilizzeremo una legenda diversa ancora una volta.
#utilizzeremo legend_set e non legend_timeline o legend_timecycle coerentemente con il codice precedente
legend_set(pal3, group_labels = names(elephant_ud))


# tubular-door-bell
sonnette d'entrée constituée de 5 tubes de cuivre avec des pic-bois sculpté utilisés comme marteaux.  Les tubes sont coupés pour former une gamme pentatonique.

## dessin de conception

![concept drawing](docs/tubular-door-bell.png)

## Ressources utiles

* Site de Lee Hite sur les [tubular wind chime](http://leehite.org/Chimes.htm)

![shmématique](docs/tubular-door-bell-schematic.png)

## programmation du MCU

* Allez dans le dossier stm8_eforth et faire la commande 
```
make -f door-bell.mk eforth
```
Maintenant stm8 eForth est programmé dans le MCU. Il faut un émulateur de terminal. Je travaille en Ubuntu 20.04 LTS et j'utilise GTKTerm comme émulateur de terminal. Sur mon PC le port utilisé pour communiqué avec le MCU via le UART2 est **/dev/ttyS0**. Voici la configuration du port dans GTKTerm. **NOTE:** la version du programmeur **STLINK** est indiquée dans le fichier **door-bell.mk**.
<br><br>
![configuration port GTKTerm](docs/config_gtkterm.png). 
<br><br>
Le délais 100 msec à la fin de chaque ligne transmise au terminal est nécessaire dans l'étape suivante pour que le forth est le temps de compiler avant la réception de la ligne suivante.

* L'application forth **doorbell.f** doit maintenant être programmée dans le MCU. Ça se fait par le transfert du fichier **doorbell.f**.<br>**Attention** j'ai édité ce fichier dans **geany** avec des fin de lignes **CR/LF** pour que le transfert s'effectue correctement. Le transfert se fait avec la commande *file -&gt; send raw file* dans GTKTerm. 

* Il y a un commentaire **\ TO-FLASH**  au début du fichier **doorbell.f**. Il faut enlevé le *back slash* pour que l'application soit compilée en mémoire flash. Autrement elle sera compilée en mémoire RAM. 

* Une fois l'application compilée en mémoire flash il faut dans le terminal eForth faire la commande 
```
AUTORUN DOORBELL
```
Pour que l'application démarre automatiquement lors de la mise sous tension de la carte.

#### Suivit du projet

Consultez le [journal](journal.md)


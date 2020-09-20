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
Maintenant stm8 eForth est programmé dans le MCU. Il faut un émulateur de terminal. Je travaille en Ubuntu 20.04 LTS et j'utilise GTKTerm comme émulateur de terminal. Sur mon PC le port utilisé pour communiqué avec le MCU via le UART2 est **/dev/ttyS0**. Voici la configuration du port dans GTKTerm. **NOTE:** la version du programmeur **STLINK** doit-être spécifiée dans le fichier **door-bell.mk**.
<br><br>
![configuration port GTKTerm](docs/config_gtkterm.png). 
<br><br>

### Programmation de l'application

* L'application en elle-même comprend 2 fichiers source Forth. 
    * **stm8s105.f** 
    * **doorbell.f**
Il doivent-être programmés dans cet ordre. J'ai créé un petit utilitaire de ligne de commande pour flasher les programmes Forth qui s'appelle **SendFile**. 

```
tubular-door-bell>SendFile/Sendfile -s /dev/ttyS0 stm8s105.f
tubular-door-bell>SendFile/SendFile -s /dev/ttyS0 doorbell.f
```

* Une fois l'application compilée en mémoire flash il faut dans le terminal eForth faire la commande 
```
AUTORUN DOORBELL
```
Pour que l'application démarre automatiquement lors de la mise sous tension de la carte.

#### Suivit du projet

Consultez le [journal](journal.md)

## Note finale

Ce projet est un échec. Le son généré par les tube de cuivre n'est pas assez puissant pour servir de sonette d'entrée. Je n'investirai donc pas plus de temps et d'argent sur ce projet. 

J'ai placé un très court [vidéo](https://youtu.be/8ZqvEC9fbHs) sur youtube

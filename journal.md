#### 2020-09-19

* L'application est complétée. J'ai divisé le code en 2 fichiers:
    * **stm8s105.f** contient les définitions spécifiques au MCU utilisé pour cette application. 
    * **doorbell.f** Contient l'application elle-même. 

* J'ai placé un très court [vidéo](https://youtu.be/8ZqvEC9fbHs) sur youtube qui montre la sonnette en action. 
  Je considère ce projet comme un échec car le volume sonore est trop faible pour servir de sonette d'entrée.

#### 2020-09-18

* retravaillé sur SendFile pour enlevé blancs et commentaire du fichier source avant de l'envoyer au MCU.

* Travail sur [application doorbell](doorbell.f), presque complété.

* Ajout de photos.

#### 2020-09-17

Le transfert du fichier Forth vers le MCU ne fonctionnant pas correctement j'ai du créer un petit utilitaire de ligne de commande pour faire le transfert. Il s'agit d'un projet séparé ajouté comme sous-module à ce projet dans le dossier SendFile.


#### 2020-09-15

* Gelé le sous module stm8_eforth en supprimant le fichier git **.gitmodules**. 

* Mise à jour documentation **README.md**

* Suppression du **Makefile** dans le dossier racine du projet.

* Travail sur **doorbell.f**. 


#### 2020-09-14

* Travail sur l'assemblage électronique. Ajout des 5 LEDs. Ne reste que l'alimentation à assembler.

* Travail sur l'application écrite en forth dans le fichier doorbell.f

#### 2020-09-11

Débuté assemblage de l'électronique. Programmé stm8_eForth sur le MCU stm8s105k6b6 


#### 2020-09-09

Assemblage mécanique complété. 

![assemblage mécanique](docs/assemblage-mécanique.png)

#### 2020-09-06

Aujourd'hui j'ai vérifié la sonorité des tubes une fois installé sur la planche. Mais ça ne fonctionne pas du tout. Si on se réfère au dessin de conception ci haut les tubes étaient maintenue sur 2 barres transversales par des vis passant à travers ceux-ci. Ce n'est pas fonctionnel ça amortie complètement les vibrations du tube. Donc je dois modifier complètement le concept. Les tubes doivent-être en suspension. Voici le nouveau concept. 
![concept révisé](docs/tubular-door-bell-concept-revised.png)

La planche est remplacée par un cadre au milieu duquel sont suspendus les tubes par des ficelles. Ce n'est pas apparent sur le dessin mais il y aura une ficelle à chaque extrémité des tubes. Les ficelles seront suffisamment tendues pour empêcher les tubes de se balancer. Les servo-moteurs et les pic-bois marteaux seront en bas.

#### 2020-09-05

Les pic-bois sont complétés et j'ai reçus les servo-moteurs. J'ai filmer un [court vidéo](https://youtu.be/YS0n4aLLaUM) d'un test de marteau sur un des tubes. Ça ne sonne pas très fort cependant.  


#### 2020-09-03

Modification au circuit pour ajouter une LED pour chaque note. 

#### 2020-09-02

Ajout du schéma électronique

#### 2020-08-31

J'ai complété la coupe des tuyaux de cuivre. J'ai utilisé le [fichier excell](docs/DIY_Millimeters_Wind_Chime_Tube_Calculator_A=440_Pentatonic_Scale.ods) trouvé sur le site de Lee Hite pour le calcul de la longueur. Pourtant les fréquences sont trop hautes. Hier j'avais utilisé une méthode empirique pour découvrir la longueur des tuyaux et j'obtenais pour une longueur de 37cm la fréquence 520 Hertz, soit très près du DO 5.  Le calculateur de Lee Hite me donne une longueur de 35,5cm pour ce tuyau et c'est trop court. Non seulement la fréquence du **DO 5** est trop haute ce qui ne serait pas si grave si les rapports de fréquence étaient juste entre les tuyaux mais ils ne le sont pas, j'entends un battement pour certaines combinaisons d'accords. J'aurais du garder ma formule déduite par expérimentation et qui me donnait des rapports justes. La formule que j'utilisais était la suivante:

**L2=L1*sqrt(f1/f2)**

* L2  longueur désirée pour la note suivante
* L1  longueur du tuyau pour la note DO5 qui était 37cm
* f1  fréquence du DO 5 soit 523,3 Hertz
* f2  fréquence de la note supérieur désirée 
* sqrt() et la racine carré

J'obtenais les valeurs suivantes:

note | fréquence | longueur tube (cm)
-|-|-
DO5|523,3 | 37
RÉ|587,3 | 34,9
MI|659,3 | 33
SOL|784 | 30,2
LA |880 | 28,5

Ceci est pour les tubes de cuivre 1/2" qu'on retrouve dans les quincalleries en Amérique du nord. le diamètre externe est de 16mm et l'interne environ 13,8mm. 

Tanpis je vais faire avec ces tuyaux même si l'accord n'est pas tout à fait juste. 

J'ai commencé à sculpter les martaux pic-bois. Il me reste à les sabler à et à les peindre. 

Demain je vais commencer la conception du circuit électronique.


# Návod na spustenie systému

Tento návod slúži na zostavenie a spustenie testovacieho prostredia (distrá) v programoch **QEMU** alebo **Docker**.

## 1. Inicializácia submodulov

```bash
git submodule update --init --recursive
```

> Tento krok môže trvať od 10 minút do jednej hodiny v závislosti od rýchlosti internetového pripojenia a výkonu počítača.

Dva z požadovaných submodulov (`upm` a `glibc`) sú už zahrnuté v repozitári, pretože nie sú verejne dostupné.

Niektoré submoduly (najmä tie z domény `savannah.gnu.org`) môžu vrátiť chyby 5xx alebo 4xx. Ide o bežný jav, pravdepodobne spôsobený dočasnou nedostupnosťou servera. V takom prípade stačí počkať a spustiť príkaz znovu.

---

## 2. Kompilácia systému

V koreňovom adresári projektu (tam, kde sa nachádza `Makefile`) spustite:

```bash
make all -j$(nproc)
```

Tento príkaz vykompiluje celý systém – od jadra a používateľského priestoru až po QEMU a Docker image.

* Prepínač `-j` je veľmi dôležitý – určuje počet paralelných procesov. Odporúča sa použiť `$(nproc)`, čo automaticky nastaví počet vlákien podľa vášho systému.
* Kompilácia môže trvať od 1 do 24 hodín v závislosti od výkonu zariadenia. Na bežnom počítači s použitím `-j$(nproc)` by to nemalo presiahnuť 6 hodín.

> Na konci procesu sa vyžaduje zadanie hesla používateľa `root`, aby sa vytvoril QEMU target (`qemu_pair`). Ak heslo nezadáte, build zlyhá. V takom prípade spustite ručne:
>
> ```bash
> make qemu-pair-only -j$(nproc)
> ```
>
> **Nepoužívajte `make qemu-pair`**, pretože tým by ste spustili celý build odznova.

!!! **Dôležité upozornenie:** systém sa dá skompilovať len s GCC verziou 14. Verzia 15 v tomto momente nedokáže skompilovať <u>kernel</u>, ani <u>bash</u>, a staršie verzie neboli na tomto projekte testované. !!!

---

## 3. Alternatívna inkrementálna kompilácia

Ak chcete systém buildovať po častiach, môžete použiť:

```bash
make build-kernel -j$(nproc)
make build-userspace -j$(nproc)
```

(alebo alternatívne `make build`)

Potom podľa cieľového prostredia spustite:

```bash
make qemu-pair-only -j$(nproc)      # pre QEMU
make docker-image-only -j$(nproc)   # pre Docker
```

---

## 4. Spustenie v QEMU

1. Prejdite do adresára:

   ```
   build/qemu-pair
   ```
2. Spustite skript:

   ```bash
   ./run_system.sh
   ```

> Tento skript spustí testovacie prostredie v QEMU. V systéme musí byť nainštalovaný `qemu-system-x86_64`.

Po spustení QEMU:

* Otvorte menu: **View → serial0**
* Zobrazí sa konzola systému – môžete s ním okamžite pracovať.

---

## 5. Spustenie v Docker

1. Prejdite do adresára:

   ```
   build/docker
   ```
2. Spustite nasledujúce príkazy:

```bash
docker build -t test-linux-distro .
docker run -it [--rm] test-linux-distro /bin/bash
```

> Týmto spustíte systém v prostredí Docker kontajnera.


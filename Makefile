SOURCES := $(shell find . -name "*.nim" -type f)
TARGETS := Detail Evolve Player Runner Tester

all: $(TARGETS)

clean:
	rm -rf ~/.cache/nim/ $(TARGETS)

run-500000: Detail $(SOURCES)
	mkdir -p Results/detail-500000

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=50 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-500000/evolve-specialized.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=50 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeAllGenes=1 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-500000/evolve-specialized-all.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=50 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-500000/evolve-specialized-lerp.p
	nim c -d:release --threads:on -d:mode="evolve-standard" -d:draftsEval=10 -d:elites=2 -d:generations=9 -d:populationSize=12 -d:scoreGames=20 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-500000/evolve-standard.p
	nim c -d:release --threads:on -d:mode="random-exhaustive" -d:draftsEval=10 -d:generations=1 -d:populationSize=35 -d:scoreGames=20 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-500000/random-exhaustive.p
	nim c -d:release --threads:on -d:mode="random-tournament" -d:draftsEval=10 -d:generations=1 -d:populationSize=1250 -d:scoreGames=20 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-500000/random-tournament.p
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-500000/*.p | tee Results/detail-500000/detail-1.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-500000/*.p | tee Results/detail-500000/detail-2.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-500000/*.p | tee Results/detail-500000/detail-3.txt

run-1000000: Detail $(SOURCES)
	mkdir -p Results/detail-1000000

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeAllGenes=1 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-all.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-lerp.p
	nim c -d:release --threads:on -d:mode="evolve-standard" -d:draftsEval=10 -d:elites=2 -d:generations=18 -d:populationSize=12 -d:scoreGames=20 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-standard.p
	nim c -d:release --threads:on -d:mode="random-exhaustive" -d:draftsEval=10 -d:generations=1 -d:populationSize=50 -d:scoreGames=20 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/random-exhaustive.p
	nim c -d:release --threads:on -d:mode="random-tournament" -d:draftsEval=10 -d:generations=1 -d:populationSize=5000 -d:scoreGames=20 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/random-tournament.p
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-1000000/*.p | tee Results/detail-1000000/detail-1.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-1000000/*.p | tee Results/detail-1000000/detail-2.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-1000000/*.p | tee Results/detail-1000000/detail-3.txt

run-1000000-variants: Detail $(SOURCES)
	mkdir -p Results/detail-1000000-variants

	nim c -d:release --threads:on -d:mode="evolve-variant-2" -d:generations=200 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-2.1.p
	nim c -d:release --threads:on -d:mode="evolve-variant-4" -d:generations=400 -d:populationSize=100 -d:scoreGames=1  -d:scoreRounds=1 -d:tournamentGames=2 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-4.1.p

	nim c -d:release --threads:on -d:mode="evolve-variant-2" -d:generations=200 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-2.2.p
	nim c -d:release --threads:on -d:mode="evolve-variant-4" -d:generations=400 -d:populationSize=100 -d:scoreGames=1  -d:scoreRounds=1 -d:tournamentGames=2 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-4.2.p

	nim c -d:release --threads:on -d:mode="evolve-variant-2" -d:generations=200 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-2.3.p
	nim c -d:release --threads:on -d:mode="evolve-variant-4" -d:generations=400 -d:populationSize=100 -d:scoreGames=1  -d:scoreRounds=1 -d:tournamentGames=2 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-4.3.p

	nim c -d:release --threads:on -d:mode="evolve-variant-2" -d:generations=200 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-2.4.p
	nim c -d:release --threads:on -d:mode="evolve-variant-4" -d:generations=400 -d:populationSize=100 -d:scoreGames=1  -d:scoreRounds=1 -d:tournamentGames=2 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-4.4.p

	nim c -d:release --threads:on -d:mode="evolve-variant-2" -d:generations=200 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-2.5.p
	nim c -d:release --threads:on -d:mode="evolve-variant-4" -d:generations=400 -d:populationSize=100 -d:scoreGames=1  -d:scoreRounds=1 -d:tournamentGames=2 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-4.5.p

	nim c -d:release --threads:on -d:mode="evolve-variant-2" -d:generations=200 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-2.6.p
	nim c -d:release --threads:on -d:mode="evolve-variant-4" -d:generations=400 -d:populationSize=100 -d:scoreGames=1  -d:scoreRounds=1 -d:tournamentGames=2 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-4.6.p

	nim c -d:release --threads:on -d:mode="evolve-variant-2" -d:generations=200 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-2.7.p
	nim c -d:release --threads:on -d:mode="evolve-variant-4" -d:generations=400 -d:populationSize=100 -d:scoreGames=1  -d:scoreRounds=1 -d:tournamentGames=2 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-4.7.p

	nim c -d:release --threads:on -d:mode="evolve-variant-2" -d:generations=200 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-2.8.p
	nim c -d:release --threads:on -d:mode="evolve-variant-4" -d:generations=400 -d:populationSize=100 -d:scoreGames=1  -d:scoreRounds=1 -d:tournamentGames=2 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-4.8.p

	nim c -d:release --threads:on -d:mode="evolve-variant-2" -d:generations=200 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-2.9.p
	nim c -d:release --threads:on -d:mode="evolve-variant-4" -d:generations=400 -d:populationSize=100 -d:scoreGames=1  -d:scoreRounds=1 -d:tournamentGames=2 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-4.9.p

	nim c -d:release --threads:on -d:mode="evolve-variant-2" -d:generations=200 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-2.10.p
	nim c -d:release --threads:on -d:mode="evolve-variant-4" -d:generations=400 -d:populationSize=100 -d:scoreGames=1  -d:scoreRounds=1 -d:tournamentGames=2 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000-variants/evolve-variant-4.10.p

run-1000000-continue: Detail $(SOURCES)
	mkdir -p Results/detail-1000000

	nim c -d:release --threads:on -d:mode="evolve-standard" -d:draftsEval=10 -d:elites=2 -d:generations=18 -d:populationSize=12 -d:scoreGames=20 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-standard.6.p
	nim c -d:release --threads:on -d:generations=50 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 -d:activeDrafts=2 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-active-2.6.p
	nim c -d:release --threads:on -d:generations=25 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 -d:activeDrafts=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-active-4.6.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=50 -d:populationSize=100 -d:scoreGames=40 -d:scoreRounds=4 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-drafts.6.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=150 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=1 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-epochs.6.p

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized.7.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeAllGenes=1 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-all.7.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-lerp.7.p
	nim c -d:release --threads:on -d:mode="evolve-standard" -d:draftsEval=10 -d:elites=2 -d:generations=18 -d:populationSize=12 -d:scoreGames=20 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-standard.7.p
	nim c -d:release --threads:on -d:generations=50 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 -d:activeDrafts=2 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-active-2.7.p
	nim c -d:release --threads:on -d:generations=25 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 -d:activeDrafts=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-active-4.7.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=50 -d:populationSize=100 -d:scoreGames=40 -d:scoreRounds=4 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-drafts.7.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=150 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=1 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-epochs.7.p

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized.8.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeAllGenes=1 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-all.8.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-lerp.8.p
	nim c -d:release --threads:on -d:mode="evolve-standard" -d:draftsEval=10 -d:elites=2 -d:generations=18 -d:populationSize=12 -d:scoreGames=20 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-standard.8.p
	nim c -d:release --threads:on -d:generations=50 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 -d:activeDrafts=2 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-active-2.8.p
	nim c -d:release --threads:on -d:generations=25 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 -d:activeDrafts=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-active-4.8.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=50 -d:populationSize=100 -d:scoreGames=40 -d:scoreRounds=4 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-drafts.8.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=150 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=1 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-epochs.8.p

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized.9.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeAllGenes=1 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-all.9.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-lerp.9.p
	nim c -d:release --threads:on -d:mode="evolve-standard" -d:draftsEval=10 -d:elites=2 -d:generations=18 -d:populationSize=12 -d:scoreGames=20 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-standard.9.p
	nim c -d:release --threads:on -d:generations=50 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 -d:activeDrafts=2 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-active-2.9.p
	nim c -d:release --threads:on -d:generations=25 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 -d:activeDrafts=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-active-4.9.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=50 -d:populationSize=100 -d:scoreGames=40 -d:scoreRounds=4 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-drafts.9.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=150 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=1 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-epochs.9.p

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized.10.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeAllGenes=1 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-all.10.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-lerp.10.p
	nim c -d:release --threads:on -d:mode="evolve-standard" -d:draftsEval=10 -d:elites=2 -d:generations=18 -d:populationSize=12 -d:scoreGames=20 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-standard.10.p
	nim c -d:release --threads:on -d:generations=50 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 -d:activeDrafts=2 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-active-2.10.p
	nim c -d:release --threads:on -d:generations=25 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 -d:activeDrafts=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-active-4.10.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=50 -d:populationSize=100 -d:scoreGames=40 -d:scoreRounds=4 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-drafts.10.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=150 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=1 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-epochs.10.p

run-1000000-detail-x: Detail
	mkdir -p Results/detail-X-1000000

	/usr/bin/time -v ./Detail --drafts=500 --games=10 ./Results/detail-X-1000000/*.p | tee Results/detail-X-1000000/detail-1.txt
	/usr/bin/time -v ./Detail --drafts=500 --games=10 ./Results/detail-X-1000000/*.p | tee Results/detail-X-1000000/detail-2.txt
	/usr/bin/time -v ./Detail --drafts=500 --games=10 ./Results/detail-X-1000000/*.p | tee Results/detail-X-1000000/detail-3.txt
	/usr/bin/time -v ./Detail --drafts=500 --games=10 ./Results/detail-X-1000000/*.p | tee Results/detail-X-1000000/detail-4.txt
	/usr/bin/time -v ./Detail --drafts=500 --games=10 ./Results/detail-X-1000000/*.p | tee Results/detail-X-1000000/detail-5.txt

run-25000000: Detail $(SOURCES)
	mkdir -p Results/detail-25000000

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=1000 -d:populationSize=250 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-25000000/evolve-specialized.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=1000 -d:populationSize=250 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeAllGenes=1 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-25000000/evolve-specialized-all.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=1000 -d:populationSize=250 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-25000000/evolve-specialized-lerp.p
	nim c -d:release --threads:on -d:mode="evolve-standard" -d:draftsEval=10 -d:elites=2 -d:generations=52 -d:populationSize=36 -d:scoreGames=20 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-25000000/evolve-standard.p
	nim c -d:release --threads:on -d:mode="random-exhaustive" -d:draftsEval=10 -d:generations=1 -d:populationSize=250 -d:scoreGames=20 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-25000000/random-exhaustive.p
	nim c -d:release --threads:on -d:mode="random-tournament" -d:draftsEval=10 -d:generations=1 -d:populationSize=65536 -d:scoreGames=20 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-25000000/random-tournament.p
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-25000000/*.p | tee Results/detail-25000000/detail-1.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-25000000/*.p | tee Results/detail-25000000/detail-2.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-25000000/*.p | tee Results/detail-25000000/detail-3.txt

run-compare-1000000: Detail $(SOURCES)
	mkdir -p Results/detail-1000000

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=50  -d:populationSize=100 -d:scoreGames=40 -d:scoreRounds=4 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-drafts.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=150 -d:populationSize=100 -d:scoreGames=10 -d:scoreRounds=1 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-epochs.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-normal.p
	nim c -d:release --threads:on -d:mode="evolve-standard" -d:draftsEval=10 -d:elites=2 -d:generations=18 -d:populationSize=12 -d:scoreGames=20 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-standard.p
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-1000000/*.p | tee Results/detail-1000000/detail-1.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-1000000/*.p | tee Results/detail-1000000/detail-2.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-1000000/*.p | tee Results/detail-1000000/detail-3.txt

run-evolved-1000000: Detail $(SOURCES)
	mkdir -p Results/detail-1000000

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeAllGenes=1 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-all.p
	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-specialized-lerp.p
	nim c -d:release --threads:on -d:mode="evolve-standard" -d:draftsEval=10 -d:elites=2 -d:generations=18 -d:populationSize=12 -d:scoreGames=20 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/detail-1000000/evolve-standard.p
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-1000000/*.p | tee Results/detail-1000000/detail-1.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-1000000/*.p | tee Results/detail-1000000/detail-2.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/detail-1000000/*.p | tee Results/detail-1000000/detail-3.txt

run-evolve: Evolve
	rm -f fit.log plot.p *.svg
	/usr/bin/time -v ./Evolve | tee plot.p
	gnuplot plot.p
	gio open *.svg

run-runner: Runner
	/usr/bin/time -v ./Runner \
	  --p1-player=Random --p1-draft=Random3 \
	  --p2-player=Random --p2-draft=Random3 \
	  --games=10000

run-tester: Player Tester
	/usr/bin/time -v ./Tester \
	  --referee="java -Xshare:auto -XX:CICompilerCount=1 -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -XX:-UsePerfData -Xms64m -Xmx64m -jar LoCM.jar" \
	  --player1="./Player --player=Greedy --time=10" \
	  --player2="./Player --player=MCTS --time=15" \
	  --games=64 \
	  --plain=false \
	  --replays=false \
	  --threads=4

run-CEC-2020: Detail $(SOURCES)
	mkdir -p Results/CEC-2020

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-specialized.1.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-specialized.2.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-specialized.3.p & \
	wait

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeAllGenes=1 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-specialized-all.1.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-specialized-all.2.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-specialized-all.3.p & \
	wait

	nim c -d:release --threads:on -d:mode="evolve-specialized" -d:generations=100 -d:populationSize=100 -d:scoreGames=20 -d:scoreRounds=2 -d:tournamentGames=5 -d:tournamentSize=4 -d:mergeGene=25 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-specialized-lerp.1.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-specialized-lerp.2.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-specialized-lerp.3.p & \
	wait

	nim c -d:release --threads:on -d:mode="evolve-standard" -d:draftsEval=10 -d:elites=2 -d:generations=18 -d:populationSize=12 -d:scoreGames=20 -d:tournamentSize=4 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-standard.1.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-standard.2.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/evolve-standard.3.p & \
	wait

	nim c -d:release --threads:on -d:mode="random-exhaustive" -d:draftsEval=10 -d:generations=1 -d:populationSize=50 -d:scoreGames=20 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/CEC-2020/random-exhaustive.1.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/random-exhaustive.2.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/random-exhaustive.3.p & \
	wait

	nim c -d:release --threads:on -d:mode="random-tournament" -d:draftsEval=10 -d:generations=1 -d:populationSize=5000 -d:scoreGames=20 Evolve.nim
	/usr/bin/time -v ./Evolve > Results/CEC-2020/random-tournament.1.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/random-tournament.2.p & \
	/usr/bin/time -v ./Evolve > Results/CEC-2020/random-tournament.3.p & \
	wait

	/usr/bin/time -v ./Detail --drafts=2618 ./Results/CEC-2020/*.p | tee Results/CEC-2020/detail-1.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/CEC-2020/*.p | tee Results/CEC-2020/detail-2.txt
	/usr/bin/time -v ./Detail --drafts=2618 ./Results/CEC-2020/*.p | tee Results/CEC-2020/detail-3.txt

Detail: $(SOURCES)
	nim c -d:release --threads:on $@

Evolve: $(SOURCES)
	nim c -d:release --threads:on $@

Player: $(SOURCES)
	nim c -d:release $@

Runner: $(SOURCES)
	nim c -d:release $@

Tester: $(SOURCES)
	nim c -d:release $@

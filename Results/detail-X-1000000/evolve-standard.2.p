# 2019-01-31 16:59:31.851 Generation    1: avg=50.00 top5=[52.76 51.86 51.72 50.90 50.07]
# 2019-01-31 16:59:33.074 Generation    2: avg=50.00 top5=[51.60 51.43 51.30 50.86 50.83]
# 2019-01-31 16:59:34.341 Generation    3: avg=50.00 top5=[52.00 51.65 51.42 50.17 50.01]
# 2019-01-31 16:59:35.629 Generation    4: avg=50.00 top5=[52.01 51.64 50.87 50.43 50.02]
# 2019-01-31 16:59:36.936 Generation    5: avg=50.00 top5=[53.02 52.53 52.22 51.93 50.66]
# 2019-01-31 16:59:38.248 Generation    6: avg=50.00 top5=[54.20 52.16 50.93 50.18 50.00]
# 2019-01-31 16:59:39.512 Generation    7: avg=50.00 top5=[52.80 51.85 51.58 50.95 49.94]
# 2019-01-31 16:59:40.814 Generation    8: avg=50.00 top5=[51.75 51.11 50.95 50.90 50.43]
# 2019-01-31 16:59:42.114 Generation    9: avg=50.00 top5=[51.82 51.25 51.24 50.81 50.36]
# 2019-01-31 16:59:43.408 Generation   10: avg=50.00 top5=[51.16 51.09 50.91 50.75 50.44]
# 2019-01-31 16:59:44.677 Generation   11: avg=50.00 top5=[51.50 51.44 50.91 50.74 50.70]
# 2019-01-31 16:59:45.956 Generation   12: avg=50.00 top5=[51.11 51.03 50.55 50.25 50.14]
# 2019-01-31 16:59:47.228 Generation   13: avg=50.00 top5=[51.83 50.83 50.81 50.76 50.53]
# 2019-01-31 16:59:48.479 Generation   14: avg=50.00 top5=[52.17 50.72 50.44 50.43 50.41]
# 2019-01-31 16:59:49.714 Generation   15: avg=50.00 top5=[51.66 51.15 51.07 50.87 50.51]
# 2019-01-31 16:59:50.962 Generation   16: avg=50.00 top5=[51.57 51.50 51.12 51.08 51.02]
# 2019-01-31 16:59:52.247 Generation   17: avg=50.00 top5=[51.93 51.33 50.66 50.58 50.33]
# 2019-01-31 16:59:53.525 Generation   18: avg=50.00 top5=[51.35 50.68 50.27 50.25 50.17]
set output 'plot-performance.svg'
set terminal svg font 'monospace:Bold,16' linewidth 2 size 1000,600
set xlabel 'Plays'
set ylabel '% of wins'
$data <<EOD
# 2019-01-31 17:00:00.987
  55733 56.61504000004868 3.376687058056776
# 2019-01-31 17:00:08.486
  111466 56.53088000004851 3.344340346323503
# 2019-01-31 17:00:15.984
  167200 56.69728000004885 3.345290736549999
# 2019-01-31 17:00:23.523
  222933 56.56352000004857 3.242645912221126
# 2019-01-31 17:00:30.953
  278666 56.54208000004853 3.352961465935368
# 2019-01-31 17:00:38.566
  334400 56.8147200000491 3.156742706025003
# 2019-01-31 17:00:46.141
  390133 56.53216000004851 3.212005599005634
# 2019-01-31 17:00:53.643
  445866 56.81024000004909 3.259778760597849
# 2019-01-31 17:01:01.196
  501600 56.64864000004875 3.207293608019605
# 2019-01-31 17:01:08.664
  557333 56.76896000004901 3.258984303129554
# 2019-01-31 17:01:16.220
  613066 56.46848000004837 3.339804717651479
# 2019-01-31 17:01:23.743
  668800 56.60672000004867 3.280270701031458
# 2019-01-31 17:01:31.305
  724533 56.18880000004778 3.375007247406748
# 2019-01-31 17:01:38.689
  780266 56.65344000004878 3.457439996305135
# 2019-01-31 17:01:46.080
  836000 56.92384000004934 3.202443187324841
# 2019-01-31 17:01:53.666
  891733 56.68768000004884 3.222013959008219
# 2019-01-31 17:02:01.231
  947466 56.48608000004841 3.283454454084219
# 2019-01-31 17:02:08.823
  1003200 56.77536000004902 3.19721771045438
EOD
plot $data using 1:2:3 title 'evolve-standard' with errorbars
# 2019-01-31 17:02:08.824 Plays total 1003200
# 2019-01-31 17:02:08.824 Best  1: [0.3196378823607817, 0.07609630460924954, 0.3209447489752841, 0.2752983357699963, 0.04761621507691527, 0.2207217713121983, 0.4651951238418863, 0.5474277641038441, 0.9751913309612297, 0.4046770460468305, 0.7167322830260208, 0.2550825564272645, 0.7166925497228882, 0.01409023737127502, 0.8776491253472549, 0.1004280283544627, 0.4506913049392363, 0.3042586830554512, 0.971561032989567, 0.7968993519124092, 0.07588960145923584, 0.1825530806435658, 0.3275377137345152, 0.4014939781451974, 0.2199225919017891, 0.3587606834961856, 0.6541985849322578, 0.08832115299037113, 0.7991313669146478, 0.5429319098628125, 0.6955624310245774, 0.9292725054464073, 0.005787435829903931, 0.1906020950473115, 0.1418817208201553, 0.7997769113415936, 0.6059976060378962, 0.5078022253036403, 0.6998302815129973, 0.8463507182023373, 0.4570557010917133, 0.9452533539290349, 0.1717759959971645, 0.9653316223134352, 0.868123086105419, 0.1600936346055384, 0.5144509003329545, 0.8121137853612987, 0.3097560391782335, 0.1645496805239466, 0.4348796773434402, 0.1370721781808066, 0.7122909717837387, 0.1887285655442388, 0.6482742988743544, 0.04461023005049047, 0.05155023293111705, 0.05226761916813261, 0.522837909947393, 0.2352448709477577, 0.6987367814383314, 0.2011030148475397, 0.0006736466427597065, 0.556595069376874, 0.5194098595194863, 0.6185621157300907, 0.2964634698131552, 0.6063176313268779, 0.2354122839483213, 0.6239251504449497, 0.676677587458598, 0.8409701751801593, 0.3895822440412806, 0.6143812788464542, 0.8072211086384402, 0.9859406257337922, 0.9286454286531711, 0.8250943299642368, 0.4801540583714357, 0.62397878066271, 0.4787043562280022, 0.9478053632129859, 0.8759488387917238, 0.5288569261270768, 0.4066319812112955, 0.0166245453842726, 0.6558777708507295, 0.2437758991781154, 0.388021443836464, 0.2733596620218992, 0.527722755784706, 0.008416715505254357, 0.09384254348310606, 0.707984507996632, 0.09473817569207843, 0.2589043493491949, 0.008734205673537776, 0.7320959844696791, 0.6064754523325326, 0.0966034853667419, 0.4916867821506723, 0.01805969285344067, 0.6087908074749602, 0.08457309411580605, 0.7114416627188833, 0.299899821877849, 0.7989293159517343, 0.6877056103981345, 0.6625949325140923, 0.3449885919393163, 0.6666083578887021, 0.5768342396706438, 0.482162764418981, 0.3707615709715009, 0.9779384500038271, 0.08637203302939289, 0.1899869405094872, 0.1126755609931342, 0.0444641530123262, 0.8896139411513151, 0.3580503633205709, 0.9984245648116268, 0.2648653025109007, 0.2751477094808559, 0.5634025982821169, 0.6567748355434848, 0.2970499626615595, 0.9836941502868279, 0.8580128407571719, 0.05336484062457925, 0.1822014551734046, 0.8661550826022533, 0.782698695861082, 0.2550475655947679, 0.8547372836582314, 0.02520820351789155, 0.4359469367883979, 0.1019960682741436, 0.4824210307596544, 0.249449274596951, 0.4527039881672699, 0.3854738934145885, 0.648535612277533, 0.5392876939094342, 0.5308397902838391, 0.4134216750323545, 0.4642297347995361, 0.4462901859462007, 0.1821667394858109, 0.4128716549720013, 0.9321859488384541, 0.8757584806112453, 0.1722200854071028, 0.8501023034602435, 0.6759777337101807, 0.0478744400616713, 0.5978767982404003, 0.2959183434984773, 0.7909253332388533, 0.09661436244521204]
# 2019-01-31 17:02:08.824 Best  2: [0.3196378823607817, 0.07609630460924954, 0.3209447489752841, 0.07229485813423819, 0.04761621507691527, 0.2207217713121983, 0.2402254399094155, 0.1914245253813707, 0.9376086554355032, 0.4046770460468305, 0.2632859758666881, 0.2550825564272645, 0.7166925497228882, 0.01409023737127502, 0.8776491253472549, 0.1004280283544627, 0.4506913049392363, 0.3042586830554512, 0.971561032989567, 0.9099008583284618, 0.07588960145923584, 0.1825530806435658, 0.3275377137345152, 0.4014939781451974, 0.2199225919017891, 0.3587606834961856, 0.6541985849322578, 0.06394391591917947, 0.7991313669146478, 0.5429319098628125, 0.6955624310245774, 0.9292725054464073, 0.125104263335867, 0.1906020950473115, 0.1418817208201553, 0.7997769113415936, 0.6059976060378962, 0.5078022253036403, 0.6998302815129973, 0.8463507182023373, 0.9535648585920338, 0.9452533539290349, 0.1717759959971645, 0.9653316223134352, 0.868123086105419, 0.1600936346055384, 0.5144509003329545, 0.9467328794992107, 0.3097560391782335, 0.1645496805239466, 0.4348796773434402, 0.1370721781808066, 0.7122909717837387, 0.8028258073618395, 0.6482742988743544, 0.04461023005049047, 0.344214057625744, 0.05226761916813261, 0.522837909947393, 0.6204514361643454, 0.6987367814383314, 0.2011030148475397, 0.0006736466427597065, 0.556595069376874, 0.5790055274070178, 0.6185621157300907, 0.9129215741198828, 0.6063176313268779, 0.2354122839483213, 0.6239251504449497, 0.676677587458598, 0.8409701751801593, 0.3895822440412806, 0.6143812788464542, 0.8072211086384402, 0.9859406257337922, 0.9286454286531711, 0.8250943299642368, 0.4801540583714357, 0.7478063904723915, 0.4787043562280022, 0.9478053632129859, 0.8759488387917238, 0.5288569261270768, 0.4066319812112955, 0.0166245453842726, 0.6558777708507295, 0.2437758991781154, 0.388021443836464, 0.2733596620218992, 0.9511794425259554, 0.008416715505254357, 0.09384254348310606, 0.707984507996632, 0.09473817569207843, 0.2589043493491949, 0.008734205673537776, 0.2608507842265548, 0.6064754523325326, 0.0966034853667419, 0.4916867821506723, 0.01805969285344067, 0.6087908074749602, 0.08457309411580605, 0.7114416627188833, 0.299899821877849, 0.7989293159517343, 0.6877056103981345, 0.6625949325140923, 0.3449885919393163, 0.7359298637231195, 0.9322554265067842, 0.06125253383956841, 0.1036669880225767, 0.9779384500038271, 0.08637203302939289, 0.1899869405094872, 0.1126755609931342, 0.0444641530123262, 0.8896139411513151, 0.3580503633205709, 0.9984245648116268, 0.2648653025109007, 0.2751477094808559, 0.5634025982821169, 0.6567748355434848, 0.6769002622663545, 0.4340631468914209, 0.8580128407571719, 0.05336484062457925, 0.1822014551734046, 0.8661550826022533, 0.782698695861082, 0.2550475655947679, 0.8547372836582314, 0.02520820351789155, 0.4359469367883979, 0.1019960682741436, 0.4824210307596544, 0.249449274596951, 0.4527039881672699, 0.3854738934145885, 0.648535612277533, 0.5392876939094342, 0.5308397902838391, 0.4134216750323545, 0.4642297347995361, 0.4462901859462007, 0.1821667394858109, 0.4128716549720013, 0.9321859488384541, 0.8757584806112453, 0.09790330768005306, 0.8501023034602435, 0.6759777337101807, 0.4766933686745991, 0.5978767982404003, 0.4800265548918667, 0.8080831918617335, 0.6659649821565019]
# 2019-01-31 17:02:08.824 Best  3: [0.6162417202181814, 0.07609630460924954, 0.3209447489752841, 0.07229485813423819, 0.04761621507691527, 0.2207217713121983, 0.4651951238418863, 0.5474277641038441, 0.9751913309612297, 0.28027139724881, 0.8690097547718374, 0.8668237442016167, 0.7166925497228882, 0.01409023737127502, 0.8776491253472549, 0.593364344957636, 0.9469976945149043, 0.6814108879291478, 0.971561032989567, 0.7968993519124092, 0.07588960145923584, 0.1825530806435658, 0.3275377137345152, 0.1113161424386255, 0.2199225919017891, 0.3587606834961856, 0.6541985849322578, 0.09826811793712076, 0.7991313669146478, 0.556631074388741, 0.6955624310245774, 0.9292725054464073, 0.005787435829903931, 0.1906020950473115, 0.6311945146882196, 0.3200028594654227, 0.6059976060378962, 0.5078022253036403, 0.8355230444222981, 0.8463507182023373, 0.4570557010917133, 0.9452533539290349, 0.07839847571938319, 0.9653316223134352, 0.868123086105419, 0.1600936346055384, 0.5144509003329545, 0.554095529046595, 0.4579593405964959, 0.1645496805239466, 0.4348796773434402, 0.9518066857430605, 0.7122909717837387, 0.1887285655442388, 0.6482742988743544, 0.04461023005049047, 0.05155023293111705, 0.05226761916813261, 0.7029239474509204, 0.2352448709477577, 0.6987367814383314, 0.2011030148475397, 0.0006736466427597065, 0.556595069376874, 0.2589610352698946, 0.6185621157300907, 0.2964634698131552, 0.6063176313268779, 0.2354122839483213, 0.6239251504449497, 0.6105027806058898, 0.8409701751801593, 0.8970621324874393, 0.6143812788464542, 0.8072211086384402, 0.9859406257337922, 0.9286454286531711, 0.4246850777365581, 0.4801540583714357, 0.62397878066271, 0.4787043562280022, 0.9478053632129859, 0.06071878587923285, 0.5132637154672481, 0.5143674246488592, 0.0166245453842726, 0.6558777708507295, 0.2437758991781154, 0.388021443836464, 0.3601545408990774, 0.527722755784706, 0.008416715505254357, 0.09384254348310606, 0.707984507996632, 0.3993385395384792, 0.2589043493491949, 0.4917612556549493, 0.7320959844696791, 0.6064754523325326, 0.8684495444928246, 0.4916867821506723, 0.01805969285344067, 0.6087908074749602, 0.08457309411580605, 0.7114416627188833, 0.17161869665353, 0.7989293159517343, 0.4343870741634164, 0.6696348590104453, 0.3449885919393163, 0.2018323654729599, 0.5768342396706438, 0.495882105987103, 0.3707615709715009, 0.5259050110719441, 0.08637203302939289, 0.8783400754631934, 0.1126755609931342, 0.0444641530123262, 0.8896139411513151, 0.3580503633205709, 0.9984245648116268, 0.2648653025109007, 0.2751477094808559, 0.5634025982821169, 0.6567748355434848, 0.2970499626615595, 0.9836941502868279, 0.8580128407571719, 0.05336484062457925, 0.6465118179754374, 0.8661550826022533, 0.4222759364409177, 0.2550475655947679, 0.3489756355212921, 0.02520820351789155, 0.7459868570923185, 0.1019960682741436, 0.4824210307596544, 0.249449274596951, 0.3418484649143216, 0.3854738934145885, 0.648535612277533, 0.4249378285569503, 0.1257644601299259, 0.4134216750323545, 0.4642297347995361, 0.4331364397653978, 0.1821667394858109, 0.4128716549720013, 0.006623425490392298, 0.8757584806112453, 0.1722200854071028, 0.8501023034602435, 0.6759777337101807, 0.0478744400616713, 0.5978767982404003, 0.2959183434984773, 0.7909253332388533, 0.09661436244521204]
# 2019-01-31 17:02:08.824 Best  4: [0.6162417202181814, 0.07609630460924954, 0.3209447489752841, 0.07229485813423819, 0.04761621507691527, 0.2207217713121983, 0.2402254399094155, 0.1914245253813707, 0.9376086554355032, 0.28027139724881, 0.7975381005259663, 0.8668237442016167, 0.7166925497228882, 0.01409023737127502, 0.8776491253472549, 0.1004280283544627, 0.4506913049392363, 0.3042586830554512, 0.971561032989567, 0.9099008583284618, 0.07588960145923584, 0.1825530806435658, 0.3275377137345152, 0.1113161424386255, 0.2199225919017891, 0.3587606834961856, 0.6541985849322578, 0.06394391591917947, 0.7991313669146478, 0.556631074388741, 0.6955624310245774, 0.9292725054464073, 0.125104263335867, 0.1906020950473115, 0.6311945146882196, 0.3200028594654227, 0.6059976060378962, 0.5078022253036403, 0.8355230444222981, 0.8463507182023373, 0.9535648585920338, 0.9452533539290349, 0.07839847571938319, 0.9653316223134352, 0.868123086105419, 0.1600936346055384, 0.5144509003329545, 0.554095529046595, 0.4579593405964959, 0.1645496805239466, 0.4348796773434402, 0.9518066857430605, 0.7122909717837387, 0.8028258073618395, 0.6482742988743544, 0.04461023005049047, 0.344214057625744, 0.05226761916813261, 0.7029239474509204, 0.6204514361643454, 0.6987367814383314, 0.2011030148475397, 0.0006736466427597065, 0.556595069376874, 0.5790055274070178, 0.6185621157300907, 0.9129215741198828, 0.6063176313268779, 0.2354122839483213, 0.6239251504449497, 0.676677587458598, 0.8409701751801593, 0.3895822440412806, 0.6143812788464542, 0.8072211086384402, 0.9859406257337922, 0.9286454286531711, 0.4246850777365581, 0.4801540583714357, 0.7478063904723915, 0.4787043562280022, 0.9478053632129859, 0.06071878587923285, 0.5132637154672481, 0.5143674246488592, 0.0166245453842726, 0.6558777708507295, 0.2437758991781154, 0.04464076475768364, 0.3601545408990774, 0.9511794425259554, 0.008416715505254357, 0.09384254348310606, 0.707984507996632, 0.3993385395384792, 0.2079272515039086, 0.4917612556549493, 0.2608507842265548, 0.6064754523325326, 0.8684495444928246, 0.4916867821506723, 0.01805969285344067, 0.529308879098878, 0.08457309411580605, 0.7114416627188833, 0.299899821877849, 0.7989293159517343, 0.6877056103981345, 0.6696348590104453, 0.3449885919393163, 0.6724861997678255, 0.9322554265067842, 0.06125253383956841, 0.1036669880225767, 0.5259050110719441, 0.08637203302939289, 0.8783400754631934, 0.1126755609931342, 0.0444641530123262, 0.8896139411513151, 0.3580503633205709, 0.9984245648116268, 0.2648653025109007, 0.3696584937078362, 0.5634025982821169, 0.6567748355434848, 0.6769002622663545, 0.4340631468914209, 0.8580128407571719, 0.05336484062457925, 0.6465118179754374, 0.8661550826022533, 0.4222759364409177, 0.2550475655947679, 0.7131329359211167, 0.02520820351789155, 0.4359469367883979, 0.1019960682741436, 0.4824210307596544, 0.249449274596951, 0.3418484649143216, 0.3854738934145885, 0.648535612277533, 0.4249378285569503, 0.1257644601299259, 0.4134216750323545, 0.4642297347995361, 0.6263716056580528, 0.1821667394858109, 0.4128716549720013, 0.006623425490392298, 0.8757584806112453, 0.09790330768005306, 0.8501023034602435, 0.6759777337101807, 0.4766933686745991, 0.5978767982404003, 0.4800265548918667, 0.8080831918617335, 0.6659649821565019]
# 2019-01-31 17:02:08.824 Best  5: [0.3196378823607817, 0.07609630460924954, 0.3209447489752841, 0.07229485813423819, 0.04761621507691527, 0.2207217713121983, 0.2402254399094155, 0.1914245253813707, 0.9376086554355032, 0.4046770460468305, 0.2632859758666881, 0.2550825564272645, 0.7166925497228882, 0.01409023737127502, 0.8776491253472549, 0.1004280283544627, 0.4506913049392363, 0.3042586830554512, 0.971561032989567, 0.9099008583284618, 0.07588960145923584, 0.1825530806435658, 0.3275377137345152, 0.4014939781451974, 0.2199225919017891, 0.3587606834961856, 0.6541985849322578, 0.06394391591917947, 0.7991313669146478, 0.5429319098628125, 0.6955624310245774, 0.9292725054464073, 0.125104263335867, 0.1906020950473115, 0.1418817208201553, 0.7997769113415936, 0.6059976060378962, 0.5078022253036403, 0.6998302815129973, 0.8463507182023373, 0.9535648585920338, 0.9452533539290349, 0.1717759959971645, 0.9653316223134352, 0.868123086105419, 0.1600936346055384, 0.5144509003329545, 0.9467328794992107, 0.3097560391782335, 0.1645496805239466, 0.4348796773434402, 0.1370721781808066, 0.7122909717837387, 0.8028258073618395, 0.6482742988743544, 0.04461023005049047, 0.344214057625744, 0.05226761916813261, 0.522837909947393, 0.6204514361643454, 0.6987367814383314, 0.2011030148475397, 0.0006736466427597065, 0.556595069376874, 0.5790055274070178, 0.6185621157300907, 0.9129215741198828, 0.6063176313268779, 0.2354122839483213, 0.6239251504449497, 0.676677587458598, 0.8409701751801593, 0.3895822440412806, 0.6143812788464542, 0.8072211086384402, 0.9859406257337922, 0.9286454286531711, 0.8250943299642368, 0.4801540583714357, 0.7478063904723915, 0.4787043562280022, 0.9478053632129859, 0.8759488387917238, 0.5288569261270768, 0.4066319812112955, 0.0166245453842726, 0.6558777708507295, 0.2437758991781154, 0.388021443836464, 0.2733596620218992, 0.9511794425259554, 0.008416715505254357, 0.09384254348310606, 0.707984507996632, 0.09473817569207843, 0.2589043493491949, 0.008734205673537776, 0.2608507842265548, 0.6064754523325326, 0.0966034853667419, 0.4916867821506723, 0.01805969285344067, 0.6087908074749602, 0.08457309411580605, 0.7114416627188833, 0.299899821877849, 0.7989293159517343, 0.6877056103981345, 0.6625949325140923, 0.3449885919393163, 0.7359298637231195, 0.9322554265067842, 0.06125253383956841, 0.1036669880225767, 0.9779384500038271, 0.08637203302939289, 0.1899869405094872, 0.1126755609931342, 0.0444641530123262, 0.8896139411513151, 0.3580503633205709, 0.9984245648116268, 0.2648653025109007, 0.2751477094808559, 0.5634025982821169, 0.6567748355434848, 0.6769002622663545, 0.4340631468914209, 0.8580128407571719, 0.05336484062457925, 0.1822014551734046, 0.8661550826022533, 0.782698695861082, 0.2550475655947679, 0.8547372836582314, 0.02520820351789155, 0.4359469367883979, 0.1019960682741436, 0.4824210307596544, 0.249449274596951, 0.4527039881672699, 0.3854738934145885, 0.648535612277533, 0.5392876939094342, 0.5308397902838391, 0.4134216750323545, 0.4642297347995361, 0.4462901859462007, 0.1821667394858109, 0.4128716549720013, 0.9321859488384541, 0.8757584806112453, 0.09790330768005306, 0.8501023034602435, 0.6759777337101807, 0.4766933686745991, 0.5978767982404003, 0.4800265548918667, 0.8080831918617335, 0.6659649821565019]
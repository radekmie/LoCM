# 2019-01-22 12:44:49.863 Generation    1: avg=50.00 top5=[52.82 51.27 50.80 50.37 50.19]
# 2019-01-22 12:44:52.698 Generation    2: avg=50.00 top5=[51.41 51.02 50.94 50.84 50.76]
# 2019-01-22 12:44:55.667 Generation    3: avg=50.00 top5=[53.50 52.92 52.89 51.07 50.34]
# 2019-01-22 12:44:58.592 Generation    4: avg=50.00 top5=[52.50 52.06 51.18 50.95 50.81]
# 2019-01-22 12:45:01.530 Generation    5: avg=50.00 top5=[51.62 51.18 50.97 50.77 50.65]
# 2019-01-22 12:45:04.448 Generation    6: avg=50.00 top5=[52.12 51.70 51.68 50.61 50.40]
# 2019-01-22 12:45:07.390 Generation    7: avg=50.00 top5=[52.25 50.64 50.61 50.34 50.11]
# 2019-01-22 12:45:10.318 Generation    8: avg=50.00 top5=[51.53 51.27 51.10 51.08 50.75]
# 2019-01-22 12:45:13.225 Generation    9: avg=50.00 top5=[51.41 51.37 51.32 51.20 50.68]
# 2019-01-22 12:45:16.117 Generation   10: avg=50.00 top5=[50.82 50.76 50.61 50.61 50.44]
# 2019-01-22 12:45:18.978 Generation   11: avg=50.00 top5=[51.34 51.06 50.87 50.78 50.24]
# 2019-01-22 12:45:21.759 Generation   12: avg=50.00 top5=[51.05 50.53 50.45 50.34 50.26]
# 2019-01-22 12:45:24.529 Generation   13: avg=50.00 top5=[51.14 50.82 50.67 50.60 50.02]
# 2019-01-22 12:45:27.364 Generation   14: avg=50.00 top5=[51.30 51.02 50.94 50.76 50.75]
# 2019-01-22 12:45:30.050 Generation   15: avg=50.00 top5=[50.57 50.56 50.40 50.40 50.30]
# 2019-01-22 12:45:32.808 Generation   16: avg=50.00 top5=[51.12 51.09 50.95 50.68 50.24]
# 2019-01-22 12:45:35.640 Generation   17: avg=50.00 top5=[51.83 50.95 50.67 50.57 50.26]
# 2019-01-22 12:45:38.448 Generation   18: avg=50.00 top5=[51.53 51.19 50.83 50.74 50.65]
set output 'plot-performance.svg'
set terminal svg font 'monospace:Bold,16' linewidth 2 size 1000,600
set xlabel 'Plays'
set ylabel '% of wins'
$data <<EOD
# 2019-01-22 12:45:45.096
  55733 59.4719999999888 2.896310756806096
# 2019-01-22 12:45:51.417
  111466 59.05439999998903 2.899168984379953
# 2019-01-22 12:45:58.271
  167200 58.79999999998917 3.014296601197355
# 2019-01-22 12:46:05.367
  222933 58.81759999998916 3.073060494033518
# 2019-01-22 12:46:12.716
  278666 58.83519999998915 3.186292390850022
# 2019-01-22 12:46:19.656
  334400 58.94479999998909 2.894272136477618
# 2019-01-22 12:46:26.610
  390133 58.49519999998934 3.144216786417413
# 2019-01-22 12:46:33.686
  445866 58.99039999998907 3.362569969530369
# 2019-01-22 12:46:41.044
  501600 59.02719999998904 3.359078921369293
# 2019-01-22 12:46:48.879
  557333 58.89679999998911 3.220871186494191
# 2019-01-22 12:46:56.072
  613066 59.69519999998867 3.186771908999567
# 2019-01-22 12:47:02.869
  668800 58.45359999998936 3.074809392464763
# 2019-01-22 12:47:09.468
  724533 58.82879999998916 2.95417318381816
# 2019-01-22 12:47:16.076
  780266 59.33599999998887 3.246842158157417
# 2019-01-22 12:47:22.754
  836000 58.79199999998917 3.11708196876329
# 2019-01-22 12:47:29.466
  891733 58.27279999998946 3.339305796118055
# 2019-01-22 12:47:36.086
  947466 59.62719999998872 3.021373727295232
# 2019-01-22 12:47:43.134
  1003200 59.66879999998869 3.415994613576998
EOD
plot $data using 1:2:3 title 'evolve-standard' with errorbars
# 2019-01-22 12:47:43.134 Plays total 1003200
# 2019-01-22 12:47:43.134 Best  1: [0.6282240905902687, 0.5812948887775697, 0.3283846086352693, 0.4598235181605275, 0.3579490220569184, 0.7038376585999027, 0.7280320723808085, 0.4399849699064291, 0.1119389343216413, 0.9347007173118722, 0.5699699368719002, 0.4867351512893772, 0.4666819523618713, 0.2240220427128155, 0.9356795612501903, 0.2169104585054464, 0.49728696553226, 0.4855964487732378, 0.4969349028374268, 0.1376709589887808, 0.3568166701539326, 0.08929447875286733, 0.8964463298900642, 0.3566507627648192, 0.348483454703026, 0.5288160098481589, 0.3954310875064757, 0.01019183890632003, 0.01384136487170351, 0.8392136899807683, 0.4408542297447759, 0.7283112320455942, 0.6998663277187902, 0.6105822139340855, 0.606615536510662, 0.2579011724892897, 0.7083379899882878, 0.9897182946119014, 0.228577128611845, 0.9416356894534266, 0.6262698995907594, 0.09760541326725591, 0.03386246605797383, 0.1259697689735737, 0.9107387342617494, 0.04932411256526814, 0.01369007084717588, 0.3916606040527619, 0.5885485444630867, 0.3259985220202379, 0.8745693398342838, 0.3498639753347472, 0.1658894120353913, 0.7022967883072295, 0.1015153456498048, 0.1837358332930747, 0.4838545483119443, 0.762687581832598, 0.3744757049064331, 0.05777665597341408, 0.3726373140853785, 0.9357736567764976, 0.4919915239562538, 0.3744204088668674, 0.08505558255422896, 0.3656453264889861, 0.3252579349140148, 0.872191680683186, 0.8520650460488457, 0.8233688803132502, 0.3575300974758002, 0.3259916245333436, 0.1790770687042684, 0.6362737863969461, 0.02691583013158838, 0.49839351062963, 0.6618368699556667, 0.3295263868120686, 0.3836140873962519, 0.6892839515584364, 0.2117079479015358, 0.421365903614173, 0.7100783316603168, 0.5569640152566708, 0.4463758104028235, 0.09936565758218152, 0.01354411482598561, 0.5228310499665887, 0.8088539913918829, 0.1760297339587331, 0.9310369929820665, 0.03632279338732336, 0.05696684654890616, 0.3170610586569049, 0.6653743104755885, 0.002566138373689464, 0.02237413071179595, 0.5716899988382087, 0.2508957752208922, 0.3380624645400394, 0.9168842272457893, 0.6159237535523785, 0.5252896120831378, 0.3261005343303647, 0.6120311726582885, 0.4453835812079978, 0.9089023236501905, 0.4221142886891776, 0.2454725421643495, 0.06192177090141016, 0.8835456491595541, 0.4398775107100654, 0.8526262132927436, 0.8344323446301753, 0.9206896361215309, 0.9657502434001504, 0.8046255794684636, 0.6602049138283737, 0.6368267576928874, 0.2952026857058374, 0.09607270028847048, 0.0282383856190509, 0.8222941863581905, 0.04883376947708173, 0.339746958611157, 0.01709892137556479, 0.8349941385493906, 0.6559256085386767, 0.156244470323502, 0.9912631310954665, 0.2930389701225358, 0.001297059603151851, 0.1247448350303679, 0.7659142642491639, 0.3771397675814461, 0.7431148356660529, 0.4857976697913597, 0.1913984022166575, 0.2574961334558201, 0.3026621275932868, 0.1910135746399595, 0.9837819640617007, 0.3300687799883943, 0.03042670826579008, 0.5041234546199558, 0.04088417632832964, 0.1892431041095393, 0.2606508052536987, 0.2027640786044036, 0.4094821861654656, 0.4613104392651484, 0.7927961940432766, 0.6895027179784221, 0.01476083507343517, 0.4567761802694006, 0.1037019864578694, 0.07056782181778432, 0.6962112359140167, 0.4467311111279482, 0.1700601205018333]
# 2019-01-22 12:47:43.134 Best  2: [0.9221648796203281, 0.4077066361289889, 0.3283846086352693, 0.4598235181605275, 0.5037878094853134, 0.7038376585999027, 0.7280320723808085, 0.4399849699064291, 0.1119389343216413, 0.9347007173118722, 0.5699699368719002, 0.4867351512893772, 0.8060150363983563, 0.5690961044042799, 0.9356795612501903, 0.2169104585054464, 0.49728696553226, 0.4855964487732378, 0.4969349028374268, 0.6178872676102816, 0.3568166701539326, 0.08929447875286733, 0.8964463298900642, 0.3566507627648192, 0.348483454703026, 0.5288160098481589, 0.3954310875064757, 0.4500333670815502, 0.1769951270263372, 0.8392136899807683, 0.4408542297447759, 0.7283112320455942, 0.6998663277187902, 0.6105822139340855, 0.606615536510662, 0.2579011724892897, 0.7083379899882878, 0.9897182946119014, 0.228577128611845, 0.9416356894534266, 0.6262698995907594, 0.09760541326725591, 0.03386246605797383, 0.1259697689735737, 0.9107387342617494, 0.04932411256526814, 0.01369007084717588, 0.9120433822700369, 0.5885485444630867, 0.5574077615428019, 0.8745693398342838, 0.3498639753347472, 0.1658894120353913, 0.7022967883072295, 0.1015153456498048, 0.1837358332930747, 0.4838545483119443, 0.762687581832598, 0.3744757049064331, 0.6676025996271633, 0.05485368694107318, 0.9357736567764976, 0.3836753211024051, 0.3744204088668674, 0.08505558255422896, 0.890623358442838, 0.7352811431498345, 0.872191680683186, 0.8520650460488457, 0.8233688803132502, 0.3575300974758002, 0.5025239603578655, 0.1790770687042684, 0.6362737863969461, 0.02691583013158838, 0.49839351062963, 0.6618368699556667, 0.3295263868120686, 0.3836140873962519, 0.6892839515584364, 0.2117079479015358, 0.5611444979836271, 0.7100783316603168, 0.5569640152566708, 0.4463758104028235, 0.3575505031748316, 0.5603637103447696, 0.5228310499665887, 0.8088539913918829, 0.7670669913512729, 0.9310369929820665, 0.03632279338732336, 0.05696684654890616, 0.3170610586569049, 0.6653743104755885, 0.8066579793603117, 0.448452632719299, 0.5716899988382087, 0.6204657676905367, 0.3380624645400394, 0.9168842272457893, 0.6159237535523785, 0.6971012508239243, 0.8228630281400904, 0.6120311726582885, 0.4453835812079978, 0.9089023236501905, 0.4221142886891776, 0.2454725421643495, 0.06192177090141016, 0.8835456491595541, 0.4398775107100654, 0.8526262132927436, 0.8344323446301753, 0.9206896361215309, 0.9657502434001504, 0.8046255794684636, 0.8465673486204444, 0.6368267576928874, 0.2952026857058374, 0.804108141088868, 0.0282383856190509, 0.1449605916918979, 0.04883376947708173, 0.09912788493042513, 0.01709892137556479, 0.8349941385493906, 0.6559256085386767, 0.156244470323502, 0.5377027880028336, 0.1364129849819546, 0.001297059603151851, 0.8242561581285699, 0.2833497181157765, 0.3771397675814461, 0.7431148356660529, 0.4857976697913597, 0.33426866999879, 0.9713264223576907, 0.2992807507177828, 0.1910135746399595, 0.9837819640617007, 0.3300687799883943, 0.8029133902720886, 0.5041234546199558, 0.04088417632832964, 0.1892431041095393, 0.2606508052536987, 0.4308939359969302, 0.1684905277138722, 0.4613104392651484, 0.7927961940432766, 0.6895027179784221, 0.01476083507343517, 0.4567761802694006, 0.1037019864578694, 0.07056782181778432, 0.6962112359140167, 0.7580721867950293, 0.1700601205018333]
# 2019-01-22 12:47:43.134 Best  3: [0.6282240905902687, 0.5812948887775697, 0.3283846086352693, 0.4598235181605275, 0.5037878094853134, 0.7038376585999027, 0.7280320723808085, 0.4399849699064291, 0.1119389343216413, 0.9347007173118722, 0.5699699368719002, 0.4867351512893772, 0.8060150363983563, 0.2240220427128155, 0.9356795612501903, 0.2169104585054464, 0.49728696553226, 0.4855964487732378, 0.4969349028374268, 0.1376709589887808, 0.3568166701539326, 0.08929447875286733, 0.8964463298900642, 0.3566507627648192, 0.348483454703026, 0.5288160098481589, 0.3954310875064757, 0.01019183890632003, 0.01384136487170351, 0.8392136899807683, 0.4408542297447759, 0.7283112320455942, 0.6998663277187902, 0.6105822139340855, 0.606615536510662, 0.2579011724892897, 0.7083379899882878, 0.9897182946119014, 0.228577128611845, 0.9416356894534266, 0.6262698995907594, 0.09760541326725591, 0.4096842483222407, 0.1259697689735737, 0.9107387342617494, 0.04932411256526814, 0.01369007084717588, 0.3916606040527619, 0.5885485444630867, 0.3259985220202379, 0.8745693398342838, 0.3498639753347472, 0.1658894120353913, 0.7022967883072295, 0.1015153456498048, 0.1837358332930747, 0.4838545483119443, 0.762687581832598, 0.3744757049064331, 0.05777665597341408, 0.05485368694107318, 0.9357736567764976, 0.4919915239562538, 0.3744204088668674, 0.08505558255422896, 0.3656453264889861, 0.3252579349140148, 0.872191680683186, 0.3666576777563701, 0.8233688803132502, 0.3575300974758002, 0.3259916245333436, 0.8340687398211482, 0.6362737863969461, 0.02691583013158838, 0.49839351062963, 0.6618368699556667, 0.3295263868120686, 0.3836140873962519, 0.6892839515584364, 0.8899207175778823, 0.421365903614173, 0.7100783316603168, 0.5569640152566708, 0.4463758104028235, 0.09936565758218152, 0.01354411482598561, 0.7674068878501255, 0.8088539913918829, 0.1760297339587331, 0.9310369929820665, 0.03632279338732336, 0.05696684654890616, 0.3170610586569049, 0.6653743104755885, 0.002566138373689464, 0.05725061679464449, 0.5716899988382087, 0.2508957752208922, 0.3380624645400394, 0.9168842272457893, 0.6159237535523785, 0.5798955077683166, 0.8228630281400904, 0.6120311726582885, 0.4453835812079978, 0.9089023236501905, 0.4221142886891776, 0.2454725421643495, 0.06192177090141016, 0.8835456491595541, 0.4398775107100654, 0.8526262132927436, 0.8344323446301753, 0.9206896361215309, 0.9657502434001504, 0.8046255794684636, 0.6602049138283737, 0.6368267576928874, 0.2952026857058374, 0.09607270028847048, 0.0282383856190509, 0.1449605916918979, 0.04883376947708173, 0.339746958611157, 0.01709892137556479, 0.8349941385493906, 0.6559256085386767, 0.07618825945842955, 0.9912631310954665, 0.1364129849819546, 0.001297059603151851, 0.1247448350303679, 0.7659142642491639, 0.3771397675814461, 0.7431148356660529, 0.4857976697913597, 0.1913984022166575, 0.2574961334558201, 0.3026621275932868, 0.1910135746399595, 0.9837819640617007, 0.3300687799883943, 0.03042670826579008, 0.5041234546199558, 0.04088417632832964, 0.1892431041095393, 0.2606508052536987, 0.2027640786044036, 0.4094821861654656, 0.4613104392651484, 0.7927961940432766, 0.6895027179784221, 0.01476083507343517, 0.4567761802694006, 0.1037019864578694, 0.07056782181778432, 0.6962112359140167, 0.4467311111279482, 0.1700601205018333]
# 2019-01-22 12:47:43.134 Best  4: [0.6282240905902687, 0.5812948887775697, 0.3283846086352693, 0.4598235181605275, 0.5037878094853134, 0.5161060966521238, 0.7280320723808085, 0.4399849699064291, 0.1119389343216413, 0.9347007173118722, 0.5699699368719002, 0.4867351512893772, 0.8060150363983563, 0.2240220427128155, 0.9356795612501903, 0.2169104585054464, 0.02737139829352064, 0.5766246033664066, 0.4527231855372928, 0.1376709589887808, 0.6565889141944627, 0.08929447875286733, 0.5148854569382293, 0.3566507627648192, 0.348483454703026, 0.5288160098481589, 0.3954310875064757, 0.01019183890632003, 0.01384136487170351, 0.8392136899807683, 0.4408542297447759, 0.7283112320455942, 0.9105309788971099, 0.6105822139340855, 0.606615536510662, 0.2579011724892897, 0.8729384273230489, 0.469361655229388, 0.228577128611845, 0.9416356894534266, 0.6262698995907594, 0.09760541326725591, 0.03386246605797383, 0.1259697689735737, 0.9107387342617494, 0.04932411256526814, 0.01369007084717588, 0.3916606040527619, 0.5885485444630867, 0.4180028586211977, 0.8745693398342838, 0.3498639753347472, 0.1658894120353913, 0.9297910532337608, 0.1015153456498048, 0.1837358332930747, 0.4838545483119443, 0.762687581832598, 0.3744757049064331, 0.05777665597341408, 0.932069883221686, 0.8605057962513829, 0.4919915239562538, 0.3744204088668674, 0.08505558255422896, 0.890623358442838, 0.7352811431498345, 0.872191680683186, 0.3666576777563701, 0.8233688803132502, 0.6929771506160283, 0.3259916245333436, 0.8340687398211482, 0.6362737863969461, 0.02691583013158838, 0.49839351062963, 0.6618368699556667, 0.3295263868120686, 0.3836140873962519, 0.6892839515584364, 0.2117079479015358, 0.421365903614173, 0.7100783316603168, 0.5569640152566708, 0.4463758104028235, 0.09936565758218152, 0.5603637103447696, 0.5228310499665887, 0.8088539913918829, 0.7670669913512729, 0.5164214767869844, 0.03632279338732336, 0.05696684654890616, 0.7894248142893636, 0.6653743104755885, 0.002566138373689464, 0.448452632719299, 0.5716899988382087, 0.7140265106990424, 0.3380624645400394, 0.9168842272457893, 0.6159237535523785, 0.5252896120831378, 0.8228630281400904, 0.8023684599061685, 0.4453835812079978, 0.8445938380516744, 0.4221142886891776, 0.2454725421643495, 0.06192177090141016, 0.8835456491595541, 0.4398775107100654, 0.4177597724418596, 0.8344323446301753, 0.9206896361215309, 0.9657502434001504, 0.8046255794684636, 0.6602049138283737, 0.6368267576928874, 0.2952026857058374, 0.7620103535185776, 0.0282383856190509, 0.1449605916918979, 0.04883376947708173, 0.9952610629146219, 0.01709892137556479, 0.3394810890925521, 0.6559256085386767, 0.07618825945842955, 0.9912631310954665, 0.413614199770648, 0.1859077190425007, 0.7499957096034151, 0.7659142642491639, 0.3771397675814461, 0.7431148356660529, 0.4857976697913597, 0.1913984022166575, 0.2574961334558201, 0.3026621275932868, 0.6459036296023526, 0.5411275381835443, 0.8358320251976492, 0.03042670826579008, 0.5041234546199558, 0.04088417632832964, 0.1892431041095393, 0.2606508052536987, 0.8283481503707468, 0.4094821861654656, 0.4613104392651484, 0.7927961940432766, 0.6895027179784221, 0.01476083507343517, 0.4567761802694006, 0.1037019864578694, 0.4155975696048755, 0.6962112359140167, 0.7580721867950293, 0.1700601205018333]
# 2019-01-22 12:47:43.134 Best  5: [0.9221648796203281, 0.5812948887775697, 0.2281293829795763, 0.4598235181605275, 0.5037878094853134, 0.8216973459388239, 0.7280320723808085, 0.4399849699064291, 0.1119389343216413, 0.3465949972800715, 0.3132426833621811, 0.4867351512893772, 0.8070428853159497, 0.2240220427128155, 0.9356795612501903, 0.8716824895452915, 0.02737139829352064, 0.748238060101299, 0.4969349028374268, 0.6178872676102816, 0.5853155932169523, 0.08929447875286733, 0.8964463298900642, 0.1109766182367715, 0.348483454703026, 0.9930619740423603, 0.2606261150749096, 0.01019183890632003, 0.01384136487170351, 0.8392136899807683, 0.4408542297447759, 0.02361665852415129, 0.6998663277187902, 0.6105822139340855, 0.606615536510662, 0.2911004227828047, 0.8729384273230489, 0.469361655229388, 0.9870283492614214, 0.9416356894534266, 0.6262698995907594, 0.09760541326725591, 0.03386246605797383, 0.1259697689735737, 0.9107387342617494, 0.04932411256526814, 0.01369007084717588, 0.3916606040527619, 0.8094969434400341, 0.413404735770925, 0.8350846333814113, 0.3498639753347472, 0.1658894120353913, 0.7022967883072295, 0.3200950438889463, 0.9984287276114687, 0.4838545483119443, 0.762687581832598, 0.3744757049064331, 0.05777665597341408, 0.05485368694107318, 0.9357736567764976, 0.4919915239562538, 0.05402226079536598, 0.1715183269965554, 0.890623358442838, 0.7352811431498345, 0.872191680683186, 0.8520650460488457, 0.8233688803132502, 0.6862721421541906, 0.3259916245333436, 0.9880547754108828, 0.6362737863969461, 0.1608198175154802, 0.49839351062963, 0.108485904520778, 0.3295263868120686, 0.3836140873962519, 0.9740279346599729, 0.8033331816693876, 0.5611444979836271, 0.294005447684262, 0.5569640152566708, 0.339391206360214, 0.3415254502738223, 0.5603637103447696, 0.5228310499665887, 0.7617343836769686, 0.7670669913512729, 0.6546667896104699, 0.03632279338732336, 0.05696684654890616, 0.6085940830523799, 0.7669214865195901, 0.002566138373689464, 0.448452632719299, 0.5716899988382087, 0.2508957752208922, 0.3380624645400394, 0.9168842272457893, 0.5085165499488633, 0.6971012508239243, 0.8251783191171553, 0.6120311726582885, 0.562734039740407, 0.5647401704651533, 0.4590833847665512, 0.4437887462071353, 0.9368060728353174, 0.8835456491595541, 0.4398775107100654, 0.8526262132927436, 0.8344323446301753, 0.9206896361215309, 0.9657502434001504, 0.8046255794684636, 0.8465673486204444, 0.6368267576928874, 0.2952026857058374, 0.804108141088868, 0.0282383856190509, 0.1449605916918979, 0.7138067524161187, 0.09912788493042513, 0.01709892137556479, 0.8349941385493906, 0.6559256085386767, 0.156244470323502, 0.5377027880028336, 0.1173781228241708, 0.001297059603151851, 0.7499957096034151, 0.2882900242946456, 0.3771397675814461, 0.7431148356660529, 0.4857976697913597, 0.33426866999879, 0.9369494942993679, 0.2822446389073994, 0.4457997131547946, 0.9837819640617007, 0.3300687799883943, 0.8029133902720886, 0.5041234546199558, 0.04088417632832964, 0.1892431041095393, 0.4222739830319531, 0.4308939359969302, 0.1684905277138722, 0.3966712328342787, 0.7927961940432766, 0.6895027179784221, 0.01476083507343517, 0.5812519770044722, 0.1037019864578694, 0.07056782181778432, 0.6962112359140167, 0.4467311111279482, 0.1700601205018333]
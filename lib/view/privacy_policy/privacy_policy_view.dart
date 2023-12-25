import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Gizlilik Politikası',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Son Güncellenme: 25/12/2023',
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Güvenliğiniz bizim için önemli. Bu sebeple bizimle paylaşacağınız kişisel verileriz hassasiyetle korunmaktadır.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Biz, Aral Mezunları Derneği, veri sorumlusu olarak, bu gizlilik ve kişisel verilerin korunması politikası ile, hangi kişisel verilerinizin hangi amaçla işleneceği, işlenen verilerin kimlerle ve neden paylaşılabileceği, veri işleme yöntemimiz ve hukuki sebeplerimiz ile; işlenen verilerinize ilişkin haklarınızın neler olduğu hususunda sizleri aydınlatmayı amaçlıyoruz.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Toplanan Kişisel Verileriniz, Toplanma Yöntemi ve Hukuki Sebebi',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Kimlik, iletişim, özlük, sosyal medya, finans bilgileriniz ile görsel ve işitsel kayıtlarınız tarafımızca, çerezler (cookies) vb. teknolojiler vasıtasıyla, otomatik veya otomatik olmayan yöntemlerle ve bazen de analitik sağlayıcılar, reklam ağları, arama bilgi sağlayıcıları, teknoloji sağlayıcıları gibi üçüncü taraflardan elde edilerek, kaydedilerek, depolanarak ve güncellenerek, aramızdaki hizmet ve sözleşme ilişkisi çerçevesinde ve süresince, meşru menfaat işleme şartına dayanılarak işlenecektir.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Kişisel Verilerinizin İşlenme Amacı',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Bizimle paylaştığınız kişisel verileriniz; hizmetlerimizden faydalanabilmeniz amacıyla sizlerle sözleşmeler kurabilmek, sunduğumuz hizmetlerin gerekliliklerini en iyi şekilde ve aramızdaki sözleşmelere uygun olarak yerine getirebilmek, bu sözleşmelerden doğan haklarınızın tarafınızca kullanılmasını sağlayabilmek, ürün ve hizmetlerimizi, ihtiyaçlarınız doğrultusunda geliştirebilmek ve bu gelişmelerden sizleri haberdar edebilmek, ayrıca sizleri daha geniş kapsamlı hizmet sağlayıcıları ile yasal çerçeveler içerisinde buluşturabilmek ve kanundan doğan zorunlulukların (kişisel verilerin talep halinde adli ve idari makamlarla paylaşılması) yerine getirilebilmesi amacıyla, sözleşme ve hizmet süresince, amacına uygun ve ölçülü bir şekilde işlenecek ve güncellenecektir.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Toplanan Kişisel Verilerin Kimlere ve Hangi Amaçlarla Aktarılabileceği',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Bizimle paylaştığınız kişisel verileriniz; faaliyetlerimizi yürütmek üzere hizmet aldığımız ve/veya verdiğimiz, sözleşmesel ilişki içerisinde bulunduğumuz, iş birliği yaptığımız, yurt içi ve yurt dışındaki 3. şahıslar ile kurum ve kuruluşlara ve talep halinde adli ve idari makamlara, gerekli teknik ve idari önlemler alınması koşulu ile aktarılabilecektir.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Kişisel Verileri İşlenen Kişi Olarak Haklarınız',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'KVKK madde 11 uyarınca herkes, veri sorumlusuna başvurarak aşağıdaki haklarını kullanabilir:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '• Kişisel veri işlenip işlenmediğini öğrenme,',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '• Kişisel verileri işlenmişse buna ilişkin bilgi talep etme,',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '• Kişisel verilerin işlenme amacını ve bunların amacına uygun kullanılıp kullanılmadığını öğrenme,',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '• Yurt içinde veya yurt dışında kişisel verilerin aktarıldığı üçüncü kişileri bilme,',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '• Kişisel verilerin eksik veya yanlış işlenmiş olması hâlinde bunların düzeltilmesini isteme,',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '• Kişisel verilerin silinmesini veya yok edilmesini isteme,',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '• (e) ve (f) bentleri uyarınca yapılan işlemlerin, kişisel verilerin aktarıldığı üçüncü kişilere bildirilmesini isteme,',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '• İşlenen verilerin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi suretiyle kişinin kendisi aleyhine bir sonucun ortaya çıkmasına itiraz etme,',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '• Kişisel verilerin kanuna aykırı olarak işlenmesi sebebiyle zarara uğraması hâlinde zararın giderilmesini talep etme, haklarına sahiptir.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'İletişim',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sizlere talepleriniz doğrultusunda hizmet sunabilmek amacıyla, sadece gerekli olan kişisel verilerinizin, işbu gizlilik ve kişisel verilerin işlenmesi politikası uyarınca işlenmesini, kabul edip etmemek hususunda tamamen özgürsünüz. Uygulamayı kullanmaya devam ettiğiniz takdirde, kabul etmiş olduğunuz tarafımızca varsayılacaktır. Şayet kabul etmiyorsanız, lütfen uygulamayı tüm cihazlarınızdan kaldırınız. Ayrıntılı bilgi için bizimle aralmezunlardernegi@gmail.com e-mail adresi üzerinden iletişime geçmekten lütfen çekinmeyiniz.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

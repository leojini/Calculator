
![image](https://github.com/leojini/Calculator/assets/17540345/2dff7e32-b865-49b7-8fdb-71a3942420e0)

![image](https://github.com/leojini/Calculator/assets/17540345/10196a13-0b08-4b12-b168-d13122a17f90)

계산기

1. 기본 사칙연산을 보여주는 계산기앱
   - 홈화면 banner(배너) 광고를 보여준다.
   - AC 버튼 눌렀을 때 설정한 클릭 횟수를 도달했을 때 interstial(전면) 광고를 보여준다.
2. 언어: Dart, Flutter
3. 개발환경: Android Studio
4. 광고 관련 라이브러리: Admob(banner, interstial)
5. Admob 라이브러리 추가 방법
   - pubspec.yaml 파일을 열고 dependencies에 아래와 같이 google_mobile_ads: ^1.2.0 를 추가한다.
  
     ![image](https://github.com/leojini/Calculator/assets/17540345/476bdc3b-f8f5-4db6-9f1f-797377f6efa3)

   - ad_helper.dart 파일에 광고 banner, interstitial 아이디 정보와 광고 인스턴스 관리 로직을 추가한다.

     ![image](https://github.com/leojini/Calculator/assets/17540345/8eb8fa0a-6a44-4e17-9916-59bf2086dfab)

   - 홈화면에 banner(배너) 광고 추가
     : 배너 광고 사이즈만큼 홈화면 하단에 레이아웃을 잡아서 추가한다.

     ![image](https://github.com/leojini/Calculator/assets/17540345/f4ee4eb3-1a5f-4b76-8651-eb52a82cb1a7)

   - AC 버튼 눌렀을 때 설정한 클릭 횟수를 도달했을 때 interstial(전면) 광고 추가
     
     ![image](https://github.com/leojini/Calculator/assets/17540345/f5bbd92d-e6a7-4881-bb21-a579d3d4872d)


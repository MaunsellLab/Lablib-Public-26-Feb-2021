FasdUAS 1.101.10   ��   ��    k             l     ��  ��      T.J. Mahaffey | 9.9.2004     � 	 	 2   T . J .   M a h a f f e y   |   9 . 9 . 2 0 0 4   
  
 l     ��  ��      1951FDG | 8.4.2011     �   &   1 9 5 1 F D G   |   8 . 4 . 2 0 1 1      l     ��  ��    � � The code contained herein is free. Re-use at will, but please include a web bookmark or weblocation file to my website if you do.     �     T h e   c o d e   c o n t a i n e d   h e r e i n   i s   f r e e .   R e - u s e   a t   w i l l ,   b u t   p l e a s e   i n c l u d e   a   w e b   b o o k m a r k   o r   w e b l o c a t i o n   f i l e   t o   m y   w e b s i t e   i f   y o u   d o .      l     ��  ��    ; 5 Or simply some kind of acknowledgement in your code.     �   j   O r   s i m p l y   s o m e   k i n d   o f   a c k n o w l e d g e m e n t   i n   y o u r   c o d e .      l     ��������  ��  ��        l     ��  ��    X R Global variable ensures that the ProgBar subroutines can understand the fileList.     �   �   G l o b a l   v a r i a b l e   e n s u r e s   t h a t   t h e   P r o g B a r   s u b r o u t i n e s   c a n   u n d e r s t a n d   t h e   f i l e L i s t .     !   p       " " ������ 0 filelist fileList��   !  # $ # l     ��������  ��  ��   $  % & % l     �� ' (��   '   Launch ProgBar.    ( � ) )     L a u n c h   P r o g B a r . &  * + * l     ,���� , n      - . - I    �������� 0 startprogbar startProgBar��  ��   .  f     ��  ��   +  / 0 / l     ��������  ��  ��   0  1 2 1 l     �� 3 4��   3 "  <BEGIN> Your custom script.    4 � 5 5 8   < B E G I N >   Y o u r   c u s t o m   s c r i p t . 2  6 7 6 l   Q 8���� 8 O    Q 9 : 9 k   
 P ; ;  < = < r   
  > ? > n   
  @ A @ 1    ��
�� 
pnam A n   
  B C B 2    ��
�� 
cobj C 4   
 �� D
�� 
cfol D l    E���� E I   �� F��
�� .earsffdralis        afdr F 1    ��
�� 
sdsk��  ��  ��   ? o      ���� 0 filelist fileList =  G H G r    " I J I l     K���� K I    �� L��
�� .corecnte****       **** L o    ���� 0 filelist fileList��  ��  ��   J o      ���� 0 	filecount 	fileCount H  M N M l  # #�� O P��   O I C Prepare the progress bar. This 'sets up' the progress bar's state.    P � Q Q �   P r e p a r e   t h e   p r o g r e s s   b a r .   T h i s   ' s e t s   u p '   t h e   p r o g r e s s   b a r ' s   s t a t e . N  R S R n   # * T U T I   $ *�� V����  0 prepareprogbar prepareProgBar V  W X W o   $ %���� 0 	filecount 	fileCount X  Y�� Y m   % &���� ��  ��   U  f   # $ S  Z [ Z l  + +�� \ ]��   \ ' ! Open the desired ProgBar window.    ] � ^ ^ B   O p e n   t h e   d e s i r e d   P r o g B a r   w i n d o w . [  _ ` _ n   + 1 a b a I   , 1�� c���� 0 fadeinprogbar fadeinProgBar c  d�� d m   , -���� ��  ��   b  f   + , `  e f e Y   2 I g�� h i�� g k   < D j j  k l k l  < <�� m n��   m � � Increment the ProgBar window's progress bar. The 'f' variable contains a number, which is the number item currently being processed by the repeat loop.    n � o o0   I n c r e m e n t   t h e   P r o g B a r   w i n d o w ' s   p r o g r e s s   b a r .   T h e   ' f '   v a r i a b l e   c o n t a i n s   a   n u m b e r ,   w h i c h   i s   t h e   n u m b e r   i t e m   c u r r e n t l y   b e i n g   p r o c e s s e d   b y   t h e   r e p e a t   l o o p . l  p�� p n   < D q r q I   = D�� s���� $0 incrementprogbar incrementProgBar s  t u t o   = >���� 0 f   u  v w v o   > ?���� 0 	filecount 	fileCount w  x�� x m   ? @���� ��  ��   r  f   < =��  �� 0 f   h m   5 6����  i o   6 7���� 0 	filecount 	fileCount��   f  y z y l  J J�� { |��   { ( " Close the desired ProgBar window.    | � } } D   C l o s e   t h e   d e s i r e d   P r o g B a r   w i n d o w . z  ~�� ~ n   J P  �  I   K P�� �����  0 fadeoutprogbar fadeoutProgBar �  ��� � m   K L���� ��  ��   �  f   J K��   : m     � ��                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  ��  ��   7  � � � l     �� � ���   �    <END> your custom script.    � � � � 4   < E N D >   y o u r   c u s t o m   s c r i p t . �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �   Quit ProgBar.    � � � �    Q u i t   P r o g B a r . �  � � � l  R W ����� � n   R W � � � I   S W�������� 0 stopprogbar stopProgBar��  ��   �  f   R S��  ��   �  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �   SUBROUTINES BELOW    � � � � $   S U B R O U T I N E S   B E L O W �  � � � l     �� � ���   � 2 , Copy from here to the end of this document.    � � � � X   C o p y   f r o m   h e r e   t o   t h e   e n d   o f   t h i s   d o c u m e n t . �  � � � l     �� � ���   � : 4 Then, simply paste into the end of your own script.    � � � � h   T h e n ,   s i m p l y   p a s t e   i n t o   t h e   e n d   o f   y o u r   o w n   s c r i p t . �  � � � l     �� � ���   � M G This will give you all of ProgBar's syntax necessary for manipulation.    � � � � �   T h i s   w i l l   g i v e   y o u   a l l   o f   P r o g B a r ' s   s y n t a x   n e c e s s a r y   f o r   m a n i p u l a t i o n . �  � � � l     �� � ���   � l f Alternatively, you could paste the code below into a script file of its own and load it as a library.    � � � � �   A l t e r n a t i v e l y ,   y o u   c o u l d   p a s t e   t h e   c o d e   b e l o w   i n t o   a   s c r i p t   f i l e   o f   i t s   o w n   a n d   l o a d   i t   a s   a   l i b r a r y . �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � ' ! Prepare progress bar subroutine.    � � � � B   P r e p a r e   p r o g r e s s   b a r   s u b r o u t i n e . �  � � � i      � � � I      �� �����  0 prepareprogbar prepareProgBar �  � � � o      ���� 0 somemaxcount someMaxCount �  ��� � o      ���� 0 
windowname 
windowName��  ��   � O     a � � � k    ` � �  � � � r     � � � J    	 � �  � � � m    ����   �� �  � � � m    ����   �� �  ��� � m    ����   ����   � n       � � � m    ��
�� 
bacC � 4   	 �� �
�� 
cwin � o    ���� 0 
windowname 
windowName �  � � � r     � � � m    ��
�� boovtrue � n       � � � m    ��
�� 
hasS � 4    �� �
�� 
cwin � o    ���� 0 
windowname 
windowName �  � � � r    - � � � n    & � � � 4   # &�� �
�� 
cobj � m   $ %����  � J    # � �  � � � m    ����   �  � � � m    ����  �  � � � m    ����  �  � � � m    ����  �  � � � m    ����  �  � � � m     ���� e �  ��� � m     !�������   � n       � � � m   * ,��
�� 
levV � 4   & *�� �
�� 
cwin � o   ( )���� 0 
windowname 
windowName �  � � � r   . 6 � � � m   . / � � � � �   � n       � � � m   3 5��
�� 
titl � 4   / 3�� �
�� 
cwin � o   1 2���� 0 
windowname 
windowName �  � � � r   7 D � � � m   7 8����   � n       � � � m   ? C�
� 
conT � n   8 ? �  � 4   < ?�~
�~ 
proI m   = >�}�}   4   8 <�|
�| 
cwin o   : ;�{�{ 0 
windowname 
windowName �  r   E R m   E F�z�z   n       m   M Q�y
�y 
minW n   F M	
	 4   J M�x
�x 
proI m   K L�w�w 
 4   F J�v
�v 
cwin o   H I�u�u 0 
windowname 
windowName �t r   S ` o   S T�s�s 0 somemaxcount someMaxCount n       m   [ _�r
�r 
maxV n   T [ 4   X [�q
�q 
proI m   Y Z�p�p  4   T X�o
�o 
cwin o   V W�n�n 0 
windowname 
windowName�t   � m     R                                                                                      @ alis     �   JHRM                           BD ����ProgBar                                                        ����            ����  B cu            /:Applications:ProgBar    P r o g B a r  
  J H R M  Applications/ProgBar  / ��   �  l     �m�l�k�m  �l  �k    l     �j�j   ) # Increment progress bar subroutine.    � F   I n c r e m e n t   p r o g r e s s   b a r   s u b r o u t i n e .  i     !  I      �i"�h�i $0 incrementprogbar incrementProgBar" #$# o      �g�g 0 
itemnumber 
itemNumber$ %&% o      �f�f 0 somemaxcount someMaxCount& '�e' o      �d�d 0 
windowname 
windowName�e  �h  ! O     &()( k    %** +,+ r    -.- b    /0/ b    121 b    343 b    	565 b    787 m    99 �::  P r o c e s s i n g  8 o    �c�c 0 
itemnumber 
itemNumber6 m    ;; �<<    o f  4 o   	 
�b�b 0 somemaxcount someMaxCount2 m    == �>>    -  0 l   ?�a�`? n    @A@ 4    �_B
�_ 
cobjB o    �^�^ 0 
itemnumber 
itemNumberA o    �]�] 0 filelist fileList�a  �`  . n      CDC m    �\
�\ 
titlD 4    �[E
�[ 
cwinE o    �Z�Z 0 
windowname 
windowName, F�YF r    %GHG o    �X�X 0 
itemnumber 
itemNumberH n      IJI m   " $�W
�W 
conTJ n    "KLK 4    "�VM
�V 
proIM m     !�U�U L 4    �TN
�T 
cwinN o    �S�S 0 
windowname 
windowName�Y  ) m     OOR                                                                                      @ alis     �   JHRM                           BD ����ProgBar                                                        ����            ����  B cu            /:Applications:ProgBar    P r o g B a r  
  J H R M  Applications/ProgBar  / ��   PQP l     �R�Q�P�R  �Q  �P  Q RSR l     �OTU�O  T %  Fade in a progress bar window.   U �VV >   F a d e   i n   a   p r o g r e s s   b a r   w i n d o w .S WXW i    YZY I      �N[�M�N 0 fadeinprogbar fadeinProgBar[ \�L\ o      �K�K 0 
windowname 
windowName�L  �M  Z O     O]^] k    N__ `a` I   �Jb�I
�J .appScent****      � ****b 4    �Hc
�H 
cwinc o    �G�G 0 
windowname 
windowName�I  a ded r    fgf m    �F�F  g n      hih m    �E
�E 
alpVi 4    �Dj
�D 
cwinj o    �C�C 0 
windowname 
windowNamee klk r    mnm m    �B
�B boovtruen n      opo 1    �A
�A 
pvisp 4    �@q
�@ 
cwinq o    �?�? 0 
windowname 
windowNamel rsr r    "tut m     vv ?�������u o      �>�> 0 	fadevalue 	fadeValues wxw Y   # @y�=z{�<y k   - ;|| }~} r   - 5� o   - .�;�; 0 	fadevalue 	fadeValue� n      ��� m   2 4�:
�: 
alpV� 4   . 2�9�
�9 
cwin� o   0 1�8�8 0 
windowname 
windowName~ ��7� r   6 ;��� [   6 9��� o   6 7�6�6 0 	fadevalue 	fadeValue� m   7 8�� ?�������� o      �5�5 0 	fadevalue 	fadeValue�7  �= 0 i  z m   & '�4�4  { m   ' (�3�3 	�<  x ��2� I  A N�1��
�1 .coVSstaA****      � ****� n   A H��� 4   E H�0�
�0 
proI� m   F G�/�/ � 4   A E�.�
�. 
cwin� o   C D�-�- 0 
windowname 
windowName� �,��+
�, 
usTA� m   I J�*
�* boovtrue�+  �2  ^ m     ��R                                                                                      @ alis     �   JHRM                           BD ����ProgBar                                                        ����            ����  B cu            /:Applications:ProgBar    P r o g B a r  
  J H R M  Applications/ProgBar  / ��  X ��� l     �)�(�'�)  �(  �'  � ��� l     �&���&  � &   Fade out a progress bar window.   � ��� @   F a d e   o u t   a   p r o g r e s s   b a r   w i n d o w .� ��� i    ��� I      �%��$�%  0 fadeoutprogbar fadeoutProgBar� ��#� o      �"�" 0 
windowname 
windowName�#  �$  � O     =��� k    <�� ��� I   �!��
�! .coVSstoT****      � ****� n    ��� 4    � �
�  
proI� m   	 
�� � 4    ��
� 
cwin� o    �� 0 
windowname 
windowName� ���
� 
usTA� m    �
� boovtrue�  � ��� r    ��� m    �� ?�������� o      �� 0 	fadevalue 	fadeValue� ��� Y    3������ k     .�� ��� r     (��� o     !�� 0 	fadevalue 	fadeValue� n      ��� m   % '�
� 
alpV� 4   ! %��
� 
cwin� o   # $�� 0 
windowname 
windowName� ��� r   ) .��� \   ) ,��� o   ) *�� 0 	fadevalue 	fadeValue� m   * +�� ?�������� o      �� 0 	fadevalue 	fadeValue�  � 0 i  � m    �� � m    �� 	�  � ��� r   4 <��� m   4 5�
� boovfals� n      ��� 1   9 ;�
� 
pvis� 4   5 9�
�
�
 
cwin� o   7 8�	�	 0 
windowname 
windowName�  � m     ��R                                                                                      @ alis     �   JHRM                           BD ����ProgBar                                                        ����            ����  B cu            /:Applications:ProgBar    P r o g B a r  
  J H R M  Applications/ProgBar  / ��  � ��� l     ����  �  �  � ��� l     ����  �    Show progress bar window.   � ��� 4   S h o w   p r o g r e s s   b a r   w i n d o w .� ��� i    ��� I      ���� 0 showprogbar showProgBar� ��� o      �� 0 
windowname 
windowName�  �  � O     $��� k    #�� ��� I   � ���
�  .appScent****      � ****� 4    ���
�� 
cwin� o    ���� 0 
windowname 
windowName��  � ��� r    ��� m    ��
�� boovtrue� n      ��� 1    ��
�� 
pvis� 4    ���
�� 
cwin� o    ���� 0 
windowname 
windowName� ���� I   #����
�� .coVSstaA****      � ****� n    ��� 4    ���
�� 
proI� m    ���� � 4    ���
�� 
cwin� o    ���� 0 
windowname 
windowName� �����
�� 
usTA� m    ��
�� boovtrue��  ��  � m     ��R                                                                                      @ alis     �   JHRM                           BD ����ProgBar                                                        ����            ����  B cu            /:Applications:ProgBar    P r o g B a r  
  J H R M  Applications/ProgBar  / ��  � ��� l     ��������  ��  ��  � ��� l     ������  �    Hide progress bar window.   � ��� 4   H i d e   p r o g r e s s   b a r   w i n d o w .� ��� i    ��� I      ������� 0 hideprogbar hideProgBar� ���� o      ���� 0 
windowname 
windowName��  ��  � O     ��� k    �� � � I   ��
�� .coVSstoT****      � **** n     4    ��
�� 
proI m   	 
����  4    ��
�� 
cwin o    ���� 0 
windowname 
windowName ����
�� 
usTA m    ��
�� boovtrue��    �� r    	
	 m    ��
�� boovfals
 n       1    ��
�� 
pvis 4    ��
�� 
cwin o    ���� 0 
windowname 
windowName��  � m     R                                                                                      @ alis     �   JHRM                           BD ����ProgBar                                                        ����            ����  B cu            /:Applications:ProgBar    P r o g B a r  
  J H R M  Applications/ProgBar  / ��  �  l     ��������  ��  ��    l     ����   7 1 Enable 'barber pole' behavior of a progress bar.    � b   E n a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .  i     I      ������ 0 
barberpole 
barberPole �� o      ���� 0 
windowname 
windowName��  ��   O      r     m    ��
�� boovtrue n       !  m    ��
�� 
indR! n    "#" 4   	 ��$
�� 
proI$ m   
 ���� # 4    	��%
�� 
cwin% o    ���� 0 
windowname 
windowName m     &&R                                                                                      @ alis     �   JHRM                           BD ����ProgBar                                                        ����            ����  B cu            /:Applications:ProgBar    P r o g B a r  
  J H R M  Applications/ProgBar  / ��   '(' l     ��������  ��  ��  ( )*) l     ��+,��  + 8 2 Disable 'barber pole' behavior of a progress bar.   , �-- d   D i s a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .* ./. i    010 I      ��2����  0 killbarberpole killBarberPole2 3��3 o      ���� 0 
windowname 
windowName��  ��  1 O     454 r    676 m    ��
�� boovfals7 n      898 m    ��
�� 
indR9 n    :;: 4   	 ��<
�� 
proI< m   
 ���� ; 4    	��=
�� 
cwin= o    ���� 0 
windowname 
windowName5 m     >>R                                                                                      @ alis     �   JHRM                           BD ����ProgBar                                                        ����            ����  B cu            /:Applications:ProgBar    P r o g B a r  
  J H R M  Applications/ProgBar  / ��  / ?@? l     ��������  ��  ��  @ ABA l     ��CD��  C   Launch ProgBar.   D �EE     L a u n c h   P r o g B a r .B FGF i     #HIH I      �������� 0 startprogbar startProgBar��  ��  I O     
JKJ I   	������
�� .ascrnoop****      � ****��  ��  K m     LLR                                                                                      @ alis     �   JHRM                           BD ����ProgBar                                                        ����            ����  B cu            /:Applications:ProgBar    P r o g B a r  
  J H R M  Applications/ProgBar  / ��  G MNM l     ��������  ��  ��  N OPO l     ��QR��  Q   Quit ProgBar.   R �SS    Q u i t   P r o g B a r .P TUT i   $ 'VWV I      �������� 0 stopprogbar stopProgBar��  ��  W O     
XYX I   	������
�� .aevtquitnull��� ��� null��  ��  Y m     ZZR                                                                                      @ alis     �   JHRM                           BD ����ProgBar                                                        ����            ����  B cu            /:Applications:ProgBar    P r o g B a r  
  J H R M  Applications/ProgBar  / ��  U [��[ l     ��������  ��  ��  ��       ��\]^_`abcdefg��  \ ������������������������  0 prepareprogbar prepareProgBar�� $0 incrementprogbar incrementProgBar�� 0 fadeinprogbar fadeinProgBar��  0 fadeoutprogbar fadeoutProgBar�� 0 showprogbar showProgBar�� 0 hideprogbar hideProgBar�� 0 
barberpole 
barberPole��  0 killbarberpole killBarberPole�� 0 startprogbar startProgBar�� 0 stopprogbar stopProgBar
�� .aevtoappnull  �   � ****] �� �����hi����  0 prepareprogbar prepareProgBar�� ��j�� j  ������ 0 somemaxcount someMaxCount�� 0 
windowname 
windowName��  h ������ 0 somemaxcount someMaxCount�� 0 
windowname 
windowNamei ������������������������ �������������   ��
�� 
cwin
�� 
bacC
�� 
hasS�� �� �� �� e����� 
�� 
cobj
�� 
levV
�� 
titl
�� 
proI
�� 
conT
�� 
minW
�� 
maxV�� b� ^���mv*�/�,FOe*�/�,FOjm������v��/*�/�,FO�*�/�,FOj*�/�k/a ,FOj*�/�k/a ,FO�*�/�k/a ,FU^ ��!��~kl�}�� $0 incrementprogbar incrementProgBar� �|m�| m  �{�z�y�{ 0 
itemnumber 
itemNumber�z 0 somemaxcount someMaxCount�y 0 
windowname 
windowName�~  k �x�w�v�x 0 
itemnumber 
itemNumber�w 0 somemaxcount someMaxCount�v 0 
windowname 
windowNamel 
O9;=�u�t�s�r�q�p�u 0 filelist fileList
�t 
cobj
�s 
cwin
�r 
titl
�q 
proI
�p 
conT�} '� #�%�%�%�%��/%*�/�,FO�*�/�k/�,FU_ �oZ�n�mno�l�o 0 fadeinprogbar fadeinProgBar�n �kp�k p  �j�j 0 
windowname 
windowName�m  n �i�h�g�i 0 
windowname 
windowName�h 0 	fadevalue 	fadeValue�g 0 i  o 
��f�e�d�cv�b�a�`�_
�f 
cwin
�e .appScent****      � ****
�d 
alpV
�c 
pvis�b 	
�a 
proI
�` 
usTA
�_ .coVSstaA****      � ****�l P� L*�/j Oj*�/�,FOe*�/�,FO�E�O j�kh �*�/�,FO��E�[OY��O*�/�k/�el 	U` �^��]�\qr�[�^  0 fadeoutprogbar fadeoutProgBar�] �Zs�Z s  �Y�Y 0 
windowname 
windowName�\  q �X�W�V�X 0 
windowname 
windowName�W 0 	fadevalue 	fadeValue�V 0 i  r 
��U�T�S�R��Q�P��O
�U 
cwin
�T 
proI
�S 
usTA
�R .coVSstoT****      � ****�Q 	
�P 
alpV
�O 
pvis�[ >� :*�/�k/�el O�E�O k�kh �*�/�,FO��E�[OY��Of*�/�,FUa �N��M�Ltu�K�N 0 showprogbar showProgBar�M �Jv�J v  �I�I 0 
windowname 
windowName�L  t �H�H 0 
windowname 
windowNameu ��G�F�E�D�C�B
�G 
cwin
�F .appScent****      � ****
�E 
pvis
�D 
proI
�C 
usTA
�B .coVSstaA****      � ****�K %� !*�/j Oe*�/�,FO*�/�k/�el Ub �A��@�?wx�>�A 0 hideprogbar hideProgBar�@ �=y�= y  �<�< 0 
windowname 
windowName�?  w �;�; 0 
windowname 
windowNamex �:�9�8�7�6
�: 
cwin
�9 
proI
�8 
usTA
�7 .coVSstoT****      � ****
�6 
pvis�> � *�/�k/�el Of*�/�,FUc �5�4�3z{�2�5 0 
barberpole 
barberPole�4 �1|�1 |  �0�0 0 
windowname 
windowName�3  z �/�/ 0 
windowname 
windowName{ &�.�-�,
�. 
cwin
�- 
proI
�, 
indR�2 � e*�/�k/�,FUd �+1�*�)}~�(�+  0 killbarberpole killBarberPole�* �'�'   �&�& 0 
windowname 
windowName�)  } �%�% 0 
windowname 
windowName~ >�$�#�"
�$ 
cwin
�# 
proI
�" 
indR�( � f*�/�k/�,FUe �!I� �����! 0 startprogbar startProgBar�   �  �  � L�
� .ascrnoop****      � ****� � *j Uf �W������ 0 stopprogbar stopProgBar�  �  �  � Z�
� .aevtquitnull��� ��� null� � *j Ug �������
� .aevtoappnull  �   � ****� k     W��  *��  6��  ���  �  �  � �� 0 f  � � ��������
�	������ 0 startprogbar startProgBar
� 
cfol
� 
sdsk
� .earsffdralis        afdr
� 
cobj
� 
pnam� 0 filelist fileList
�
 .corecnte****       ****�	 0 	filecount 	fileCount�  0 prepareprogbar prepareProgBar� 0 fadeinprogbar fadeinProgBar� $0 incrementprogbar incrementProgBar�  0 fadeoutprogbar fadeoutProgBar� 0 stopprogbar stopProgBar� X)j+  O� H*�*�,j /�-�,E�O�j E�O)�kl+ 
O)kk+ O k�kh  )��km+ [OY��O)kk+ UO)j+  ascr  ��ޭ
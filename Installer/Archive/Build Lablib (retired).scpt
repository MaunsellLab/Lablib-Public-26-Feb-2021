FasdUAS 1.101.10   ��   ��    k             l     ����  r       	  n      
  
 1    ��
�� 
ttxt  l 	    ����  l     ����  I    ��  
�� .sysodlogaskr        TEXT  m        �    E n t e r   p a s s w o r d :  ��  
�� 
dtxt  l 	   ����  m       �    ��  ��    ��  
�� 
btns  l 
   ����  J        ��  m       �    C o n t i n u e &��  ��  ��    ��  
�� 
dflt  l 
  	  ����   m    	���� ��  ��    �� ! "
�� 
givu ! m   
 ����  " �� #��
�� 
htxt # m    ��
�� boovtrue��  ��  ��  ��  ��   	 o      ���� 0 my_pass  ��  ��     $ % $ l     ��������  ��  ��   %  & ' & l    (���� ( I   �� )��
�� .ascrcmnt****      � **** ) m     * * � + + $ F i x i n g   P e r m i s s i o n s��  ��  ��   '  , - , l   h .���� . O    h / 0 / k     g 1 1  2 3 2 I    1�� 4 5
�� .sysoexecTEXT���     TEXT 4 m     # 6 6 � 7 7 T s u d o   c h o w n   - R   r o o t : s t a f f   / D o c u m e n t s / L a b l i b 5 �� 8 9
�� 
RApw 8 o   & '���� 0 my_pass   9 �� :��
�� 
badm : m   * +��
�� boovtrue��   3  ; < ; I  2 C�� = >
�� .sysoexecTEXT���     TEXT = m   2 5 ? ? � @ @ F s u d o   c h m o d   - R   7 7 5   / D o c u m e n t s / L a b l i b > �� A B
�� 
RApw A o   8 9���� 0 my_pass   B �� C��
�� 
badm C m   < =��
�� boovtrue��   <  D E D I  D U�� F G
�� .sysoexecTEXT���     TEXT F m   D G H H � I I x s u d o   c h o w n   - R   r o o t : s t a f f   " / L i b r a r y / A p p l i c a t i o n   S u p p o r t / K n o t " G �� J K
�� 
RApw J o   J K���� 0 my_pass   K �� L��
�� 
badm L m   N O��
�� boovtrue��   E  M�� M I  V g�� N O
�� .sysoexecTEXT���     TEXT N m   V Y P P � Q Q j s u d o   c h m o d   - R   7 7 5   " / L i b r a r y / A p p l i c a t i o n   S u p p o r t / K n o t " O �� R S
�� 
RApw R o   \ ]���� 0 my_pass   S �� T��
�� 
badm T m   ` a��
�� boovtrue��  ��   0 m     U U�                                                                                  MACS  alis    Z  JHRM                       �VUFH+     j
Finder.app                                                       ��ȹ1m        ����  	                CoreServices    �V��      ȹi�       j   &   %  +JHRM:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  ��  ��   -  V W V l     ��������  ��  ��   W  X Y X l     ��������  ��  ��   Y  Z [ Z l     �� \ ]��   \ ; 5 set HomePath to path to home folder from user domain    ] � ^ ^ j   s e t   H o m e P a t h   t o   p a t h   t o   h o m e   f o l d e r   f r o m   u s e r   d o m a i n [  _ ` _ l     �� a b��   a 7 1set LablibPath to "Documents:Development:Lablib:"    b � c c b s e t   L a b l i b P a t h   t o   " D o c u m e n t s : D e v e l o p m e n t : L a b l i b : " `  d e d l  i p f���� f r   i p g h g m   i l i i � j j , J H R M : D o c u m e n t s : L a b l i b : h o      ���� 0 
lablibpath 
LablibPath��  ��   e  k l k l  q x m���� m r   q x n o n m   q t p p � q q " / D o c u m e n t s / L a b l i b o o      ���� &0 lablibinstallpath LablibInstallPath��  ��   l  r s r l     �� t u��   t > 8set LablibPathForAS to (HomePath as string) & LablibPath    u � v v p s e t   L a b l i b P a t h F o r A S   t o   ( H o m e P a t h   a s   s t r i n g )   &   L a b l i b P a t h s  w x w l  y � y���� y r   y � z { z o   y |���� 0 
lablibpath 
LablibPath { o      ���� "0 lablibpathforas LablibPathForAS��  ��   x  | } | l  � � ~���� ~ r   � �  �  n   � � � � � 1   � ���
�� 
psxp � o   � ����� "0 lablibpathforas LablibPathForAS � o      ���� 0 
lablibpath 
LablibPath��  ��   }  � � � l  � � ����� � r   � � � � � n   � � � � � 1   � ���
�� 
psxp � l  � � ����� � I  � ��� ���
�� .earsffdralis        afdr � m   � ���
�� afdrasup��  ��  ��   � o      ���� 00 applicationsupportpath ApplicationSupportPath��  ��   �  � � � l  � � ����� � r   � � � � � n   � � � � � 1   � ���
�� 
psxp � l  � � ����� � I  � ��� ���
�� .earsffdralis        afdr � m   � ���
�� afdrasup��  ��  ��   � o      ���� 00 applicationsupportpath ApplicationSupportPath��  ��   �  � � � l     �� � ���   � Y Sset x to ((HomePath as string) & "Documents:Development:Lablib_Installer:Package:")    � � � � � s e t   x   t o   ( ( H o m e P a t h   a s   s t r i n g )   &   " D o c u m e n t s : D e v e l o p m e n t : L a b l i b _ I n s t a l l e r : P a c k a g e : " ) �  � � � l  � � ����� � r   � � � � � m   � � � � � � � P J H R M : D o c u m e n t s : L a b l i b _ I n s t a l l e r : P a c k a g e : � o      ���� 0 x  ��  ��   �  � � � l  � � ����� � r   � � � � � n   � � � � � 1   � ���
�� 
psxp � o   � ����� 0 x   � o      ���� 0 packagepath PackagePath��  ��   �  � � � l  � � ����� � r   � � � � � n   � � � � � 1   � ���
�� 
psxp � l  � � ����� � b   � � � � � o   � ����� 0 x   � m   � � � � � � �   P a c k a g e _ c o n t e n t s��  ��   � o      ���� *0 packagecontentspath PackageContentsPath��  ��   �  � � � l     ��������  ��  ��   �  � � � l  � � � � � � r   � � � � � J   � � � �  � � � m   � � � � � � �  F r a m e w o r k s �  � � � m   � � � � � � �  A p p l i c a t i o n s �  ��� � m   � � � � � � �  P l u g i n s��   � o      ����  0 projectfolders projectFolders �   Frameworks must be first    � � � � 2   F r a m e w o r k s   m u s t   b e   f i r s t �  � � � l  � � ����� � r   � � � � � J   � � � �  � � � m   � � � � � � �  M a t l a b �  � � � m   � � � � � � �  R e s o u r c e s �  � � � m   � � � � � � �  U t i l i t i e s �  ��� � m   � � � � � � �  D o c u m e n t a t i o n��   � o      ���� $0 lablibsubfolders LablibSubfolders��  ��   �  � � � l     ����~��  �  �~   �  � � � l     �}�|�{�}  �|  �{   �  � � � l  � � ��z�y � I  � ��x ��w
�x .ascrcmnt****      � **** � m   � � � � � � � 4 B u i l d i n g   L a b l i b   F r a m e w o r k s�w  �z  �y   �  � � � l  � ��v�u � O   � � � � k   � �  � � � I 	�t ��s
�t .sysoexecTEXT���     TEXT � m   � � � � � � x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / F r a m e w o r k s / L a b l i b / L a b l i b . x c o d e p r o j   - t a r g e t   L a b l i b�s   �  ��r � I 
�q ��p
�q .sysoexecTEXT���     TEXT � m  
 � � � � � � x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / F r a m e w o r k s / L a b l i b I T C 1 8 / L a b l i b I T C 1 8 . x c o d e p r o j   - a l l t a r g e t s   - c o n f i g u r a t i o n   D e v e l o p m e n t�p  �r   � m   � � � ��                                                                                  MACS  alis    Z  JHRM                       �VUFH+     j
Finder.app                                                       ��ȹ1m        ����  	                CoreServices    �V��      ȹi�       j   &   %  +JHRM:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �v  �u   �  � � � l     �o�n�m�o  �n  �m   �  � � � l  ��l�k � I �j ��i
�j .ascrcmnt****      � **** � m   � � �   8 B u i l d i n g   L a b l i b   A p p l i c a t i o n s�i  �l  �k   �  l /�h�g O  / k  .  I &�f	�e
�f .sysoexecTEXT���     TEXT	 m  "

 � � x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / A p p l i c a t i o n s / K n o t / K n o t . x c o d e p r o j   - a l l t a r g e t s     - c o n f i g u r a t i o n   D e v e l o p m e n t�e   �d I '.�c�b
�c .sysoexecTEXT���     TEXT m  '* � � x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / A p p l i c a t i o n s / D a t a C o n v e r t / D a t a C o n v e r t . x c o d e p r o j   - a l l t a r g e t s     - c o n f i g u r a t i o n   D e v e l o p m e n t�b  �d   m  �                                                                                  MACS  alis    Z  JHRM                       �VUFH+     j
Finder.app                                                       ��ȹ1m        ����  	                CoreServices    �V��      ȹi�       j   &   %  +JHRM:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �h  �g    l     �a�`�_�a  �`  �_    l 07�^�] I 07�\�[
�\ .ascrcmnt****      � **** m  03 � F B u i l d i n g   L a b l i b   D a t a   D e v i c e   P l u g i n s�[  �^  �]    l 8T�Z�Y O  8T k  <S   I <C�X!�W
�X .sysoexecTEXT���     TEXT! m  <?"" �## x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / P l u g i n s / L a b l i b E y e L i n k P l u g i n / L a b l i b E y e L i n k P l u g i n . x c o d e p r o j   - a l l t a r g e t s     - c o n f i g u r a t i o n   D e v e l o p m e n t�W    $%$ I DK�V&�U
�V .sysoexecTEXT���     TEXT& m  DG'' �(( x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / P l u g i n s / L L M o u s e D a t a D e v i c e / L L M o u s e D a t a D e v i c e . x c o d e p r o j   - a l l t a r g e t s     - c o n f i g u r a t i o n   D e v e l o p m e n t�U  % )�T) I LS�S*�R
�S .sysoexecTEXT���     TEXT* m  LO++ �,, x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / P l u g i n s / L L S y n t h D a t a D e v i c e / L L S y n t h D a t a D e v i c e . x c o d e p r o j   - a l l t a r g e t s     - c o n f i g u r a t i o n   D e v e l o p m e n t�R  �T   m  89--�                                                                                  MACS  alis    Z  JHRM                       �VUFH+     j
Finder.app                                                       ��ȹ1m        ����  	                CoreServices    �V��      ȹi�       j   &   %  +JHRM:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �Z  �Y   ./. l     �Q�P�O�Q  �P  �O  / 010 l U\2�N�M2 I U\�L3�K
�L .ascrcmnt****      � ****3 m  UX44 �55 8 B u i l d i n g   L a b l i b   T a s k   P l u g i n s�K  �N  �M  1 676 l ]�8�J�I8 O  ]�9:9 k  a�;; <=< I ah�H>�G
�H .sysoexecTEXT���     TEXT> m  ad?? �@@ � x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / P l u g i n s / M T C o n t r a s t / M T C o n t r a s t . x c o d e p r o j   - a l l t a r g e t s     - c o n f i g u r a t i o n   D e v e l o p m e n t�G  = ABA I ip�FC�E
�F .sysoexecTEXT���     TEXTC m  ilDD �EE � x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / P l u g i n s / R F M a p / R F M a p . x c o d e p r o j   - a l l t a r g e t s     - c o n f i g u r a t i o n   D e v e l o p m e n t�E  B FGF I qx�DH�C
�D .sysoexecTEXT���     TEXTH m  qtII �JJ � x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / P l u g i n s / T u n i n g / T u n i n g . x c o d e p r o j   - a l l t a r g e t s     - c o n f i g u r a t i o n   D e v e l o p m e n t�C  G KLK I y��BM�A
�B .sysoexecTEXT���     TEXTM m  y|NN �OO � x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / P l u g i n s / V i d e o T e s t / V i d e o T e s t . x c o d e p r o j   - a l l t a r g e t s   - c o n f i g u r a t i o n   D e v e l o p m e n t�A  L P�@P I ���?Q�>
�? .sysoexecTEXT���     TEXTQ m  ��RR �SS � x c o d e b u i l d   - p r o j e c t   / D o c u m e n t s / L a b l i b / P l u g i n s / F i x a t e / F i x a t e . x c o d e p r o j   - a l l t a r g e t s     - c o n f i g u r a t i o n   D e v e l o p m e n t�>  �@  : m  ]^TT�                                                                                  MACS  alis    Z  JHRM                       �VUFH+     j
Finder.app                                                       ��ȹ1m        ����  	                CoreServices    �V��      ȹi�       j   &   %  +JHRM:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �J  �I  7 UVU l     �=�<�;�=  �<  �;  V WXW l ��Y�:�9Y I ���8Z�7
�8 .ascrcmnt****      � ****Z m  ��[[ �\\   C o l l e c t i n g   F i l e s�7  �:  �9  X ]^] l ��_�6�5_ O  ��`a` k  ��bb cdc l ���4�3�2�4  �3  �2  d efe l ���1gh�1  g 2 , delete and then replace the project folders   h �ii X   d e l e t e   a n d   t h e n   r e p l a c e   t h e   p r o j e c t   f o l d e r sf jkj l ���0lm�0  l C = delete the caches in the build folders because they are huge   m �nn z   d e l e t e   t h e   c a c h e s   i n   t h e   b u i l d   f o l d e r s   b e c a u s e   t h e y   a r e   h u g ek opo l ���/�.�-�/  �.  �-  p qrq l ��stus I ���,v�+
�, .sysoexecTEXT���     TEXTv b  ��wxw b  ��yzy m  ��{{ �||    r m   - R f  z o  ���*�* *0 packagecontentspath PackageContentsPathx m  ��}} �~~  / D o c u m e n t s�+  t / ) delete and recreate the Documents folder   u � R   d e l e t e   a n d   r e c r e a t e   t h e   D o c u m e n t s   f o l d e rr ��� I ���)��(
�) .sysoexecTEXT���     TEXT� b  ����� b  ����� m  ���� ���    m k d i r  � o  ���'�' *0 packagecontentspath PackageContentsPath� m  ���� ���  / D o c u m e n t s�(  � ��� I ���&��%
�& .sysoexecTEXT���     TEXT� b  ����� b  ����� m  ���� ���    m k d i r   '� o  ���$�$ *0 packagecontentspath PackageContentsPath� m  ���� ��� $ / D o c u m e n t s / L a b l i b '�%  � ��� r  ����� b  ����� b  ����� o  ���#�# *0 packagecontentspath PackageContentsPath� o  ���"�" &0 lablibinstallpath LablibInstallPath� m  ���� ���  /� o      �!�! 20 packagelablibfolderpath packageLablibFolderPath� ��� Y  ���� ���� l ������ k  ���� ��� r  ����� n  ����� 4  ����
� 
cobj� o  ���� 0 i  � o  ����  0 projectfolders projectFolders� o      �� 0 
typefolder 
typeFolder� ��� r  ����� b  ����� o  ���� 20 packagelablibfolderpath packageLablibFolderPath� o  ���� 0 
typefolder 
typeFolder� o      �� .0 packagetypefolderpath packageTypeFolderPath� ��� l   ����  �  �  � ��� t   ��� k  �� ��� l ����  � Q K	do shell script " rm -Rf " & packageTypeFolderPath -- delete, then replace   � ��� � 	 d o   s h e l l   s c r i p t   "   r m   - R f   "   &   p a c k a g e T y p e F o l d e r P a t h   - -   d e l e t e ,   t h e n   r e p l a c e� ��� I ���
� .sysoexecTEXT���     TEXT� b  ��� b  ��� b  ��� b  ��� m  �� ���    c p   - R  � o  
�� 0 
lablibpath 
LablibPath� o  �� 0 
typefolder 
typeFolder� m  �� ���   � o  �� 20 packagelablibfolderpath packageLablibFolderPath�  �  � m   ��X� ��� l ���
�  �  �
  � ��� r  (��� l $��	�� b  $��� m   �� ��� � J H R M : D o c u m e n t s : L a b l i b _ I n s t a l l e r : P a c k a g e : P a c k a g e _ c o n t e n t s : D o c u m e n t s : L a b l i b :� o   #�� 0 
typefolder 
typeFolder�	  �  � o      �� 0 y  � ��� r  )A��� n  )=��� 1  9=�
� 
pnam� n  )9��� 2  59�
� 
cfol� 4  )5��
� 
cfol� l -4���� c  -4��� o  -0� �  0 y  � m  03��
�� 
TEXT�  �  � o      ���� 0 x  � ���� Y  B��������� k  S��� ��� r  S_��� n  S[��� 4  V[���
�� 
cobj� o  YZ���� 0 j  � o  SV���� 0 x  � o      ���� 0 projectname projectName� ��� r  `{��� l `w������ b  `w��� b  `s��� b  `o��� b  `k��� b  `g   o  `c���� .0 packagetypefolderpath packageTypeFolderPath m  cf �  /� o  gj���� 0 projectname projectName� m  kn �  / b u i l d /� o  or���� 0 projectname projectName� m  sv �  . b u i l d��  ��  � o      ���� 0 mypath myPath� �� I |���	��
�� .sysoexecTEXT���     TEXT	 b  |�

 b  |� m  | �    r m   - R f   ' o  ����� 0 mypath myPath m  �� �  '��  ��  �� 0 j  � m  EF���� � n  FN 1  IM��
�� 
leng o  FI���� 0 x  ��  ��  � 1 + copy each of the project folders in Lablib   � � V   c o p y   e a c h   o f   t h e   p r o j e c t   f o l d e r s   i n   L a b l i b�  0 i  � m  ������ � n  �� 1  ����
�� 
leng o  ������  0 projectfolders projectFolders�  �  l ����������  ��  ��    l ������   !  copy the Lablib Subfolders    � 6   c o p y   t h e   L a b l i b   S u b f o l d e r s  l ����������  ��  ��    !  Y  ��"��#$��" k  ��%% &'& r  ��()( n  ��*+* 4  ����,
�� 
cobj, o  ������ 0 i  + o  ������ $0 lablibsubfolders LablibSubfolders) o      ���� 0 	subfolder  ' -.- r  ��/0/ b  ��121 o  ������ 20 packagelablibfolderpath packageLablibFolderPath2 o  ������ 0 	subfolder  0 o      ���� .0 packagetypefolderpath packageTypeFolderPath. 343 I ����5��
�� .sysoexecTEXT���     TEXT5 b  ��676 m  ��88 �99    r m   - R f  7 o  ������ .0 packagetypefolderpath packageTypeFolderPath��  4 :��: I ����;��
�� .sysoexecTEXT���     TEXT; b  ��<=< b  ��>?> b  ��@A@ b  ��BCB m  ��DD �EE    c p   - R  C o  ������ 0 
lablibpath 
LablibPathA o  ������ 0 	subfolder  ? m  ��FF �GG   = o  ������ 20 packagelablibfolderpath packageLablibFolderPath��  ��  �� 0 i  # m  ������ $ n  ��HIH 1  ����
�� 
lengI o  ������ $0 lablibsubfolders LablibSubfolders��  ! JKJ l ����������  ��  ��  K LML l ����NO��  N H B copy the plugins to the application support folder in the package   O �PP �   c o p y   t h e   p l u g i n s   t o   t h e   a p p l i c a t i o n   s u p p o r t   f o l d e r   i n   t h e   p a c k a g eM QRQ l ����������  ��  ��  R STS r  ��UVU n  ��WXW 1  ����
�� 
psxpX l ��Y����Y I ����Z��
�� .earsffdralis        afdrZ m  ����
�� afdrasup��  ��  ��  V o      ���� 0 a  T [\[ r  �]^] l � _����_ b  � `a` o  ������ *0 packagecontentspath PackageContentsPatha o  ������ 0 a  ��  ��  ^ o      ���� 0 p  \ bcb I ��d��
�� .sysoexecTEXT���     TEXTd b  efe b  ghg m  ii �jj    r m   - R f  h o  ���� *0 packagecontentspath PackageContentsPathf m  kk �ll  / L i b r a r y��  c mnm I $��o��
�� .sysoexecTEXT���     TEXTo b   pqp b  rsr m  tt �uu    m k d i r  s o  ���� *0 packagecontentspath PackageContentsPathq m  vv �ww  / L i b r a r y��  n xyx I %4��z��
�� .sysoexecTEXT���     TEXTz b  %0{|{ b  %,}~} m  %( ���    m k d i r   '~ o  (+���� *0 packagecontentspath PackageContentsPath| m  ,/�� ��� : / L i b r a r y / A p p l i c a t i o n   S u p p o r t '��  y ��� I 5D�����
�� .sysoexecTEXT���     TEXT� b  5@��� b  5<��� m  58�� ��� X   c p   - R   ' / L i b r a r y / A p p l i c a t i o n   S u p p o r t / K n o t '   '� o  8;���� *0 packagecontentspath PackageContentsPath� m  <?�� ��� : / L i b r a r y / A p p l i c a t i o n   S u p p o r t '��  � ��� l EE��������  ��  ��  � ��� l EE������  � 5 / copy the new welcome, readme and license files   � ��� ^   c o p y   t h e   n e w   w e l c o m e ,   r e a d m e   a n d   l i c e n s e   f i l e s� ��� l EE��������  ��  ��  � ��� I E\�����
�� .sysoexecTEXT���     TEXT� b  EX��� b  ET��� b  EP��� b  EL��� m  EH�� ���  c p   - f  � o  HK���� 0 packagepath PackagePath� m  LO�� ���  W e l c o m e . r t f  � o  PS���� 0 packagepath PackagePath� m  TW�� ��� > I n s t a l l _ r e s o u r c e s / E n g l i s h . l p r o j��  � ��� I ]t�����
�� .sysoexecTEXT���     TEXT� b  ]p��� b  ]l��� b  ]h��� b  ]d��� m  ]`�� ���  c p   - f  � o  `c���� 0 packagepath PackagePath� m  dg�� ���  R e a d M e . r t f  � o  hk���� 0 packagepath PackagePath� m  lo�� ��� > I n s t a l l _ r e s o u r c e s / E n g l i s h . l p r o j��  � ��� I u������
�� .sysoexecTEXT���     TEXT� b  u���� b  u���� b  u���� b  u|��� m  ux�� ���  c p   - f  � o  x{���� 0 packagepath PackagePath� m  |�� ���  L i c e n s e . r t f  � o  ������ 0 packagepath PackagePath� m  ���� ��� > I n s t a l l _ r e s o u r c e s / E n g l i s h . l p r o j��  � ��� l ����������  ��  ��  � ��� I �������
�� .sysoexecTEXT���     TEXT� b  ����� b  ����� b  ����� b  ����� m  ���� ���  c p   - f  � o  ������ 0 packagepath PackagePath� m  ���� ���  R e a d M e . r t f    � o  ������ *0 packagecontentspath PackageContentsPath� o  ������ &0 lablibinstallpath LablibInstallPath��  � ���� I �������
�� .sysoexecTEXT���     TEXT� b  ����� b  ����� b  ����� b  ����� m  ���� ���  c p   - f  � o  ������ 0 packagepath PackagePath� m  ���� ��� " R e l e a s e N o t e s . r t f  � o  ������ *0 packagecontentspath PackageContentsPath� o  ������ &0 lablibinstallpath LablibInstallPath��  ��  a m  �����                                                                                  MACS  alis    Z  JHRM                       �VUFH+     j
Finder.app                                                       ��ȹ1m        ����  	                CoreServices    �V��      ȹi�       j   &   %  +JHRM:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �6  �5  ^ ���� l     ��������  ��  ��  ��       "������ p i������� ����� �����������������~�}�|�{�z��  �  �y�x�w�v�u�t�s�r�q�p�o�n�m�l�k�j�i�h�g�f�e�d�c�b�a�`�_�^�]�\�[�Z
�y .aevtoappnull  �   � ****�x 0 my_pass  �w 0 
lablibpath 
LablibPath�v &0 lablibinstallpath LablibInstallPath�u "0 lablibpathforas LablibPathForAS�t 00 applicationsupportpath ApplicationSupportPath�s 0 x  �r 0 packagepath PackagePath�q *0 packagecontentspath PackageContentsPath�p  0 projectfolders projectFolders�o $0 lablibsubfolders LablibSubfolders�n 20 packagelablibfolderpath packageLablibFolderPath�m 0 
typefolder 
typeFolder�l .0 packagetypefolderpath packageTypeFolderPath�k 0 y  �j 0 projectname projectName�i 0 mypath myPath�h 0 	subfolder  �g 0 a  �f 0 p  �e  �d  �c  �b  �a  �`  �_  �^  �]  �\  �[  �Z  � �Y��X�W���V
�Y .aevtoappnull  �   � ****� k    ���      &  ,  d  k  w  |  �  �  �		  �

  �  �  �  �  �  �    0 6 W ]�U�U  �X  �W  � �T�S�T 0 i  �S 0 j  � v �R �Q �P�O�N�M�L�K�J�I *�H U 6�G�F�E�D ? H P i�C p�B�A�@�?�>�= ��<�; ��: � � ��9 � � � ��8 � � � �
"'+4?DINR[{}������7�6�5�4�3�2����1�0�/�.�-�,�+8DF�*�)iktv����������������
�R 
dtxt
�Q 
btns
�P 
dflt
�O 
givu�N 
�M 
htxt�L 

�K .sysodlogaskr        TEXT
�J 
ttxt�I 0 my_pass  
�H .ascrcmnt****      � ****
�G 
RApw
�F 
badm�E 
�D .sysoexecTEXT���     TEXT�C 0 
lablibpath 
LablibPath�B &0 lablibinstallpath LablibInstallPath�A "0 lablibpathforas LablibPathForAS
�@ 
psxp
�? afdrasup
�> .earsffdralis        afdr�= 00 applicationsupportpath ApplicationSupportPath�< 0 x  �; 0 packagepath PackagePath�: *0 packagecontentspath PackageContentsPath�9  0 projectfolders projectFolders�8 $0 lablibsubfolders LablibSubfolders�7 20 packagelablibfolderpath packageLablibFolderPath
�6 
leng
�5 
cobj�4 0 
typefolder 
typeFolder�3 .0 packagetypefolderpath packageTypeFolderPath�2X�1 0 y  
�0 
cfol
�/ 
TEXT
�. 
pnam�- 0 projectname projectName�, 0 mypath myPath�+ 0 	subfolder  �* 0 a  �) 0 p  �V������kv�k���e� 
�,E�O�j O� Ia a �a ea  Oa a �a ea  Oa a �a ea  Oa a �a ea  UOa E` Oa E` O_ E` O_ a ,E` Oa j a ,E`  Oa j a ,E`  Oa !E` "O_ "a ,E` #O_ "a $%a ,E` %Oa &a 'a (mvE` )Oa *a +a ,a -a vE` .Oa /j O� a 0j Oa 1j UOa 2j O� a 3j Oa 4j UOa 5j O� a 6j Oa 7j Oa 8j UOa 9j O� )a :j Oa ;j Oa <j Oa =j Oa >j UOa ?j O�(a @_ %%a A%j Oa B_ %%a C%j Oa D_ %%a E%j O_ %_ %a F%E` GO �k_ )a H,Ekh  _ )a I�/E` JO_ G_ J%E` KOa Lna M_ %_ J%a N%_ G%j oOa O_ J%E` PO*a Q_ Pa R&/a Q-a S,E` "O Mk_ "a H,Ekh _ "a I�/E` TO_ Ka U%_ T%a V%_ T%a W%E` XOa Y_ X%a Z%j [OY��[OY�QO Qk_ .a H,Ekh  _ .a I�/E` [O_ G_ [%E` KOa \_ K%j Oa ]_ %_ [%a ^%_ G%j [OY��Oa j a ,E` _O_ %_ _%E` `Oa a_ %%a b%j Oa c_ %%a d%j Oa e_ %%a f%j Oa g_ %%a h%j Oa i_ #%a j%_ #%a k%j Oa l_ #%a m%_ #%a n%j Oa o_ #%a p%_ #%a q%j Oa r_ #%a s%_ %%_ %j Oa t_ #%a u%_ %%_ %j U� �  B r o t h e r 2 1� � $ / D o c u m e n t s / L a b l i b /� � : / L i b r a r y / A p p l i c a t i o n   S u p p o r t /� �(�(    !� �""  F i x a t e �## " L L M o u s e D a t a D e v i c e �$$ " L L S y n t h D a t a D e v i c e �%% & L a b l i b E y e L i n k P l u g i n �&&  M T C o n t r a s t  �'' 
 R F M a p! �((  T u n i n g� �))  V i d e o T e s t� �** H / D o c u m e n t s / L a b l i b _ I n s t a l l e r / P a c k a g e /� �++ h / D o c u m e n t s / L a b l i b _ I n s t a l l e r / P a c k a g e / P a c k a g e _ c o n t e n t s� �',�' ,   � � �� �&-�& -   � � � �� �.. � / D o c u m e n t s / L a b l i b _ I n s t a l l e r / P a c k a g e / P a c k a g e _ c o n t e n t s / D o c u m e n t s / L a b l i b /� �// � / D o c u m e n t s / L a b l i b _ I n s t a l l e r / P a c k a g e / P a c k a g e _ c o n t e n t s / D o c u m e n t s / L a b l i b / D o c u m e n t a t i o n� �00 � J H R M : D o c u m e n t s : L a b l i b _ I n s t a l l e r : P a c k a g e : P a c k a g e _ c o n t e n t s : D o c u m e n t s : L a b l i b : P l u g i n s� �11 � / D o c u m e n t s / L a b l i b _ I n s t a l l e r / P a c k a g e / P a c k a g e _ c o n t e n t s / D o c u m e n t s / L a b l i b / P l u g i n s / V i d e o T e s t / b u i l d / V i d e o T e s t . b u i l d� �22 : / L i b r a r y / A p p l i c a t i o n   S u p p o r t /� �33 � / D o c u m e n t s / L a b l i b _ I n s t a l l e r / P a c k a g e / P a c k a g e _ c o n t e n t s / L i b r a r y / A p p l i c a t i o n   S u p p o r t /��  ��  ��  ��  ��  ��  �  �~  �}  �|  �{  �z   ascr  ��ޭ
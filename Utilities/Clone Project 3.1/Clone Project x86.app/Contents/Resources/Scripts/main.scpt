FasdUAS 1.101.10   ��   ��    k             l     ��  ��    @ : clone Project  v. 0.71  app script   (Xcode 4 compatible)     � 	 	 t   c l o n e   P r o j e c t     v .   0 . 7 1     a p p   s c r i p t       ( X c o d e   4   c o m p a t i b l e )   
  
 l     ��  ��    * $ Craig G. Hocker - HHMI - 12/14/2005     �   H   C r a i g   G .   H o c k e r   -   H H M I   -   1 2 / 1 4 / 2 0 0 5      l     ��������  ��  ��        l     ��  ��      Global variables     �   "   G l o b a l   v a r i a b l e s      l          j     �� �� 0 	nibfolder 	nibFolder  m        �    E n g l i s h . l p r o j  B < location of Interface Builder files in Xcode project folder     �   x   l o c a t i o n   o f   I n t e r f a c e   B u i l d e r   f i l e s   i n   X c o d e   p r o j e c t   f o l d e r       l      ! " # ! j    �� $�� &0 replacescriptname replaceScriptName $ m     % % � & &  m y s c r i p t . t x t " = 7 file created containing sed script for unix bash shell    # � ' ' n   f i l e   c r e a t e d   c o n t a i n i n g   s e d   s c r i p t   f o r   u n i x   b a s h   s h e l l    ( ) ( l      * + , * j    �� -��  0 oldprojectname oldProjectName - m     . . � / /  o l d p r o j e c t + 6 0 project folder name of project to be duplicated    , � 0 0 `   p r o j e c t   f o l d e r   n a m e   o f   p r o j e c t   t o   b e   d u p l i c a t e d )  1 2 1 l      3 4 5 3 j   	 �� 6�� 0 mypath myPath 6 m   	 
 7 7 � 8 8  / U s e r s / 4 1 + POSIX path to location of files or folders    5 � 9 9 V   P O S I X   p a t h   t o   l o c a t i o n   o f   f i l e s   o r   f o l d e r s 2  : ; : l      < = > < j    �� ?�� 0 
filesuffix 
fileSuffix ? m     @ @ � A A  . p l i s t = ( " file suffix changed with context     > � B B D   f i l e   s u f f i x   c h a n g e d   w i t h   c o n t e x t   ;  C D C l      E F G E p     H H ������ 0 filelist fileList��   F 9 3  all Files found in project folder and sub folders    G � I I f     a l l   F i l e s   f o u n d   i n   p r o j e c t   f o l d e r   a n d   s u b   f o l d e r s D  J K J l     �� L M��   L   list of illegal prefixes    M � N N 2   l i s t   o f   i l l e g a l   p r e f i x e s K  O P O l     Q���� Q r      R S R J      T T  U V U m      W W � X X  N S V  Y Z Y m     [ [ � \ \  N S S Z  ] ^ ] m     _ _ � ` `  V B L ^  a b a m     c c � d d  V B L C b  e f e m     g g � h h  L L f  i j i m     k k � l l  C C j  m n m m     o o � p p  G G n  q r q m     s s � t t  P B r  u v u m    	 w w � x x  P B X v  y z y m   	 
 { { � | |  P B X F z  } ~ } m   
    � � �  P B X V ~  � � � m     � � � � �  P B X B �  � � � m     � � � � �  I T �  � � � m     � � � � �  I T C �  � � � m     � � � � �  B O �  � � � m     � � � � �  B O O �  ��� � m     � � � � �  B O O L��   S o      ����  0 myreservedlist myReservedList��  ��   P  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �  //////////  subroutines    � � � � . / / / / / / / / / /     s u b r o u t i n e s �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � J D subroutine to replace old file names and prefixes with the new ones    � � � � �   s u b r o u t i n e   t o   r e p l a c e   o l d   f i l e   n a m e s   a n d   p r e f i x e s   w i t h   t h e   n e w   o n e s �  � � � i    � � � I      �� ����� &0 replacetextinfile replaceTextInFile �  � � � o      ���� 0 thefile theFile �  � � � o      ���� 0 oldtext1   �  � � � o      ���� 0 newtext1   �  � � � o      ���� 0 oldtext2   �  ��� � o      ���� 0 newtext2  ��  ��   � k    \ � �  � � � r      � � � m      � � � � �  m y t e m p . h � o      ���� 0 tempfile tempFile �  � � � O    � � � r     � � � l    ����� � I   �� ���
�� .coredoexnull���     **** � l    ����� � n     � � � 4    �� �
�� 
file � o    ���� &0 replacescriptname replaceScriptName � 4    �� �
�� 
cfol � o   
 ���� 0 mypath myPath��  ��  ��  ��  ��   � o      ���� "0 scriptfilefound scriptFileFound � m     � ��                                                                                  sevs  alis    L  JHRM                           BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p  
  J H R M  -System/Library/CoreServices/System Events.app   / ��   �  � � � Z    � � ����� � H    ! � � l     ����� � o     ���� "0 scriptfilefound scriptFileFound��  ��   � k   $ � � �  � � � r   $ 1 � � � b   $ / � � � o   $ )���� 0 mypath myPath � o   ) .���� &0 replacescriptname replaceScriptName � o      ���� 0 filename fileName �  � � � r   2 > � � � I  2 <�� � �
�� .rdwropenshor       file � 4   2 6�� �
�� 
psxf � o   4 5���� 0 filename fileName � �� ���
�� 
perm � m   7 8��
�� boovtrue��   � o      ���� 0 fileid fileID �  � � � I  ? z�� � �
�� .rdwrwritnull���     **** � b   ? r � � � b   ? n � � � b   ? h � � � b   ? d � � � b   ? b � � � b   ? ^ � � � b   ? \ � � � b   ? Z � � � b   ? T � � � b   ? R � � � b   ? P � � � b   ? N � � � b   ? H � � � b   ? F � � � b   ? D � � � b   ? B   m   ? @ �  s / \ ( [ ^ a - z A - Z ] \ ) o   @ A���� 0 oldtext2   � m   B C �  / \ 1 � o   D E���� 0 newtext2   � m   F G �  / g � l  H M���� I  H M��	��
�� .sysontocTEXT       shor	 m   H I���� 
��  ��  ��   � m   N O

 �  / ^ � o   P Q���� 0 oldtext2   � m   R S �  / {   � l  T Y���� I  T Y����
�� .sysontocTEXT       shor m   T U���� 
��  ��  ��   � m   Z [ �  s / � o   \ ]���� 0 oldtext2   � m   ^ a �  / � o   b c���� 0 newtext2   � m   d g �  / 1 � l  h m���� I  h m����
�� .sysontocTEXT       shor m   h i���� 
��  ��  ��   � m   n q �  } � ����
�� 
refn o   u v���� 0 fileid fileID��   � �� I  { �����
�� .rdwrclosnull���     **** o   { |���� 0 fileid fileID��  ��  ��  ��   �  l  � ��� ��   � �	set ShellPath to (searchReplace into myPath at (oldProjectName & " ") given replaceString:oldProjectName & "\\ ") -- uses global variable to overcome POSIX issue with spaces in names     �!!n 	 s e t   S h e l l P a t h   t o   ( s e a r c h R e p l a c e   i n t o   m y P a t h   a t   ( o l d P r o j e c t N a m e   &   "   " )   g i v e n   r e p l a c e S t r i n g : o l d P r o j e c t N a m e   &   " \ \   " )   - -   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e s "#" l  � �$%&$ r   � �'(' l  � �)����) I  � �����*�� 0 searchreplace searchReplace��  * ��+,
�� 
into+ o   � ����� 0 mypath myPath, ��-.
�� 
at  - l  � �/����/ m   � �00 �11   ��  ��  . ��2���� 0 replacestring replaceString2 m   � �33 �44  \ %��  ��  ��  ( o      ���� 0 	shellpath 	ShellPath% H B uses global variable to overcome POSIX issue with spaces in names   & �55 �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e s# 676 r   � �898 l  � �:����: I  � �����;�� 0 searchreplace searchReplace��  ; ��<=
�� 
into< o   � ����� 0 	shellpath 	ShellPath= ��>?
�� 
at  > m   � �@@ �AA  %? ��B���� 0 replacestring replaceStringB m   � �CC �DD   ��  ��  ��  9 o      ���� 0 	shellpath 	ShellPath7 EFE r   �GHG b   �IJI b   �KLK b   � MNM b   � �OPO b   � �QRQ b   � �STS b   � �UVU b   � �WXW b   � �YZY b   � �[\[ b   � �]^] b   � �_`_ b   � �aba b   � �cdc b   � �efe b   � �ghg b   � �iji b   � �klk b   � �mnm b   � �opo b   � �qrq b   � �sts b   � �uvu b   � �wxw m   � �yy �zz 
 c a t    x o   � ����� 0 	shellpath 	ShellPathv o   � ����� 0 thefile theFilet m   � �{{ �||    >  r o   � ����� 0 	shellpath 	ShellPathp o   � ����� 0 tempfile tempFilen m   � �}} �~~    ;  l m   � � ���      >  j o   � ����� 0 	shellpath 	ShellPathh o   � ����� 0 thefile theFilef m   � ��� ���    ;  d m   � ��� ���    s e d   - e   ' s /b o   � ����� 0 oldtext1  ` m   � ��� ���  /^ o   � ����� 0 newtext1  \ m   � ��� ���  / g '  Z o   � ����� 0 	shellpath 	ShellPathX o   � ����� 0 tempfile tempFileV m   � ��� ���    >  T o   � ����� 0 	shellpath 	ShellPathR o   � ����� 0 thefile theFileP m   � ��� ���    ;  N m   � ��� ���    >L o   ���� 0 	shellpath 	ShellPathJ o  ���� 0 tempfile tempFileH o      ���� 0 cmd  F ��� I ���~
� .sysoexecTEXT���     TEXT� o  �}�} 0 cmd  �~  � ��� r  V��� b  T��� b  R��� b  P��� b  L��� b  H��� b  F��� b  D��� b  @��� b  >��� b  <��� b  8��� b  2��� b  0��� b  ,��� b  (��� b  &��� b  $��� b   ��� b  ��� b  ��� b  ��� b  ��� b  ��� m  �� ���  c a t  � o  �|�| 0 	shellpath 	ShellPath� o  �{�{ 0 thefile theFile� m  �� ���    >  � o  �z�z 0 	shellpath 	ShellPath� o  �y�y 0 tempfile tempFile� m  �� ���    ;  � m   #�� ���    >  � o  $%�x�x 0 	shellpath 	ShellPath� o  &'�w�w 0 thefile theFile� m  (+�� ���    ;  � m  ,/�� ���    s e d   - f  � o  01�v�v 0 	shellpath 	ShellPath� o  27�u�u &0 replacescriptname replaceScriptName� m  8;�� ���   � o  <=�t�t 0 	shellpath 	ShellPath� o  >?�s�s 0 tempfile tempFile� m  @C�� ���    >  � o  DE�r�r 0 	shellpath 	ShellPath� o  FG�q�q 0 thefile theFile� m  HK�� ���    ;  � m  LO�� ���    r m   - f  � o  PQ�p�p 0 	shellpath 	ShellPath� o  RS�o�o 0 tempfile tempFile� o      �n�n 0 cmd  � ��m� I W\�l��k
�l .sysoexecTEXT���     TEXT� o  WX�j�j 0 cmd  �k  �m   � ��� l     �i�h�g�i  �h  �g  � ��� l     �f���f  � U O simple form of replaceTextinFile subroutine to handle plist and project files    � ��� �   s i m p l e   f o r m   o f   r e p l a c e T e x t i n F i l e   s u b r o u t i n e   t o   h a n d l e   p l i s t   a n d   p r o j e c t   f i l e s  � ��� i   ��� I      �e��d�e &0 simplereplacetext simpleReplaceText� ��� o      �c�c 0 thefile theFile� ��� o      �b�b 0 oldtext  � ��a� o      �`�` 0 newtext newText�a  �d  � k     _�� ��� l    ���� r     ��� c     	��� b     ��� m     �� ���  t e m p� o    �_�_ 0 
filesuffix 
fileSuffix� m    �^
�^ 
TEXT� o      �]�] 0 tempfile tempFile� %  use global variable fileSuffix   � ��� >   u s e   g l o b a l   v a r i a b l e   f i l e S u f f i x� ��� l   ���� r    � � l   �\�[ I   �Z�Y�Z 0 searchreplace searchReplace�Y   �X
�X 
into o    �W�W 0 mypath myPath �V
�V 
at   l   �U�T m     �		   �U  �T   �S
�R�S 0 replacestring replaceString
 m     �  \ %�R  �\  �[    o      �Q�Q 0 	shellpath 	ShellPath� H B uses global variable to overcome POSIX issue with spaces in names   � � �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e s�  r    + l   )�P�O I   )�N�M�N 0 searchreplace searchReplace�M   �L
�L 
into o     !�K�K 0 	shellpath 	ShellPath �J
�J 
at   m   " # �  % �I�H�I 0 replacestring replaceString m   $ % �   �H  �P  �O   o      �G�G 0 	shellpath 	ShellPath  l  , Y ! r   , Y"#" b   , W$%$ b   , U&'& b   , Q()( b   , O*+* b   , K,-, b   , I./. b   , E010 b   , C232 b   , ?454 b   , =676 b   , ;898 b   , 9:;: b   , 7<=< b   , 5>?> b   , 3@A@ b   , 1BCB b   , /DED m   , -FF �GG  b a s h ;   c d  E o   - .�F�F 0 	shellpath 	ShellPathC m   / 0HH �II  ;   c a t  A o   1 2�E�E 0 thefile theFile? m   3 4JJ �KK    >  = o   5 6�D�D 0 tempfile tempFile; m   7 8LL �MM  ;   >9 o   9 :�C�C 0 thefile theFile7 m   ; <NN �OO  ;   s e d   - e   ' s /5 o   = >�B�B 0 oldtext  3 m   ? BPP �QQ  /1 o   C D�A�A 0 newtext newText/ m   E HRR �SS  / g '  - o   I J�@�@ 0 tempfile tempFile+ m   K NTT �UU    >  ) o   O P�?�? 0 thefile theFile' m   Q TVV �WW  ;   r m   - f  % o   U V�>�> 0 tempfile tempFile# o      �=�= 0 cmd      and clean up!   ! �XX    a n d   c l e a n   u p ! Y�<Y I  Z _�;Z�:
�; .sysoexecTEXT���     TEXTZ o   Z [�9�9 0 cmd  �:  �<  � [\[ l     �8�7�6�8  �7  �6  \ ]^] l     �5_`�5  _ j d universal search and replace subroutine -- operates strictly in AppleScript on a string or document   ` �aa �   u n i v e r s a l   s e a r c h   a n d   r e p l a c e   s u b r o u t i n e   - -   o p e r a t e s   s t r i c t l y   i n   A p p l e S c r i p t   o n   a   s t r i n g   o r   d o c u m e n t^ bcb i    ded I      �4�3f�4 0 searchreplace searchReplace�3  f �2gh
�2 
intog o      �1�1 0 
mainstring 
mainStringh �0ij
�0 
at  i o      �/�/ 0 searchstring searchStringj �.k�-�. 0 replacestring replaceStringk o      �,�, 0 replacestring replaceString�-  e k     Sll mnm V     Popo l   Kqrsq k    Ktt uvu l   �+wx�+  w v p we use offset command here to derive the position within the document where the search string first appears       x �yy �   w e   u s e   o f f s e t   c o m m a n d   h e r e   t o   d e r i v e   t h e   p o s i t i o n   w i t h i n   t h e   d o c u m e n t   w h e r e   t h e   s e a r c h   s t r i n g   f i r s t   a p p e a r s        v z{z r    |}| I   �*�)~
�* .sysooffslong    ��� null�)  ~ �(�
�( 
psof o   
 �'�' 0 searchstring searchString� �&��%
�& 
psin� o    �$�$ 0 
mainstring 
mainString�%  } o      �#�# 0 foundoffset foundOffset{ ��� l   �"���"  � � � begin assembling remade string by getting all text up to the search location, minus the first character of the search string      � ���    b e g i n   a s s e m b l i n g   r e m a d e   s t r i n g   b y   g e t t i n g   a l l   t e x t   u p   t o   t h e   s e a r c h   l o c a t i o n ,   m i n u s   t h e   f i r s t   c h a r a c t e r   o f   t h e   s e a r c h   s t r i n g      � ��� Z    /���!�� =   ��� o    � �  0 foundoffset foundOffset� m    �� � l   ���� r    ��� m    �� ���  � o      �� 0 stringstart stringStart� \ V search string starts at beginning, most likely to occur when searching a small string   � ��� �   s e a r c h   s t r i n g   s t a r t s   a t   b e g i n n i n g ,   m o s t   l i k e l y   t o   o c c u r   w h e n   s e a r c h i n g   a   s m a l l   s t r i n g�!  � r     /��� n     -��� 7  ! -���
� 
ctxt� m   % '�� � l  ( ,���� \   ( ,��� o   ) *�� 0 foundoffset foundOffset� m   * +�� �  �  � o     !�� 0 
mainstring 
mainString� o      �� 0 stringstart stringStart� ��� l  0 0����  � / ) get the end part of the remade string      � ��� R   g e t   t h e   e n d   p a r t   o f   t h e   r e m a d e   s t r i n g      � ��� r   0 C��� n   0 A��� 7  1 A���
� 
ctxt� l  5 =���� [   5 =��� o   6 7�� 0 foundoffset foundOffset� l  7 <���� I  7 <���
� .corecnte****       ****� o   7 8�� 0 searchstring searchString�  �  �  �  �  � m   > @����� o   0 1�
�
 0 
mainstring 
mainString� o      �	�	 0 	stringend 	stringEnd� ��� l  D D����  � C = remake mainString to start, replace string and end string      � ��� z   r e m a k e   m a i n S t r i n g   t o   s t a r t ,   r e p l a c e   s t r i n g   a n d   e n d   s t r i n g      � ��� r   D K��� b   D I��� b   D G��� o   D E�� 0 stringstart stringStart� o   E F�� 0 replacestring replaceString� o   G H�� 0 	stringend 	stringEnd� o      �� 0 
mainstring 
mainString�  r 6 0 will not do anything if search string not found   s ��� `   w i l l   n o t   d o   a n y t h i n g   i f   s e a r c h   s t r i n g   n o t   f o u n dp E    ��� o    �� 0 
mainstring 
mainString� o    �� 0 searchstring searchStringn �� � l  Q S���� L   Q S�� o   Q R���� 0 
mainstring 
mainString� "  ship it back to the caller    � ��� 8   s h i p   i t   b a c k   t o   t h e   c a l l e r  �   c ��� l     ��������  ��  ��  � ��� i   ��� I      ������� 0 upcase upCase� ���� o      ���� 0 astring aString��  ��  � k     P�� ��� r     ��� m     �� ���  � o      ���� 
0 buffer  � ��� Y    M�������� k    H�� ��� r    ��� l   ������ I   �����
�� .sysoctonshor       TEXT� n    ��� 4    ���
�� 
cobj� o    ���� 0 i  � o    ���� 0 astring aString��  ��  ��  � o      ���� 0 testchar testChar� ��� l   ��������  ��  ��  � ��� Z    F������ F    (��� @     ��� o    ���� 0 testchar testChar� m    ���� a� B   # &��� o   # $���� 0 testchar testChar� m   $ %���� z� k   + 8�� ��� l  + +������  � D > if lowercase ascii character then change to uppercase version   � ��� |   i f   l o w e r c a s e   a s c i i   c h a r a c t e r   t h e n   c h a n g e   t o   u p p e r c a s e   v e r s i o n� ��� r   + 6��� b   + 4��� o   + ,���� 
0 buffer  � l  , 3������ I  , 3�����
�� .sysontocTEXT       shor� l  , /������ \   , /   o   , -���� 0 testchar testChar m   - .����  ��  ��  ��  ��  ��  � o      ���� 
0 buffer  � �� l  7 7��������  ��  ��  ��  ��  � k   ; F  l  ; ;����     do not chage character    � .   d o   n o t   c h a g e   c h a r a c t e r 	
	 r   ; D b   ; B o   ; <���� 
0 buffer   l  < A���� I  < A����
�� .sysontocTEXT       shor l  < =���� o   < =���� 0 testchar testChar��  ��  ��  ��  ��   o      ���� 
0 buffer  
 �� l  E E��������  ��  ��  ��  � �� l  G G��������  ��  ��  ��  �� 0 i  � m    ���� � I   ����
�� .corecnte****       **** o    	���� 0 astring aString��  ��  �  l  N N��������  ��  ��   �� L   N P o   N O���� 
0 buffer  ��  �  l     ��������  ��  ��    l     ��������  ��  ��    l     �� ��     T.J. Mahaffey | 9.9.2004     �!! 2   T . J .   M a h a f f e y   |   9 . 9 . 2 0 0 4 "#" l     ��$%��  $   1951FDG | 8.4.2011   % �&& &   1 9 5 1 F D G   |   8 . 4 . 2 0 1 1# '(' l     ��)*��  ) � � The code contained herein is free. Re-use at will, but please include a web bookmark or weblocation file to my website if you do.   * �++   T h e   c o d e   c o n t a i n e d   h e r e i n   i s   f r e e .   R e - u s e   a t   w i l l ,   b u t   p l e a s e   i n c l u d e   a   w e b   b o o k m a r k   o r   w e b l o c a t i o n   f i l e   t o   m y   w e b s i t e   i f   y o u   d o .( ,-, l     ��./��  . ; 5 Or simply some kind of acknowledgement in your code.   / �00 j   O r   s i m p l y   s o m e   k i n d   o f   a c k n o w l e d g e m e n t   i n   y o u r   c o d e .- 121 l     ��������  ��  ��  2 343 l     ��56��  5 ' ! Prepare progress bar subroutine.   6 �77 B   P r e p a r e   p r o g r e s s   b a r   s u b r o u t i n e .4 898 i    ":;: I      ��<����  0 prepareprogbar prepareProgBar< =>= o      ���� 0 somemaxcount someMaxCount> ?��? o      ���� 0 
windowname 
windowName��  ��  ; O     a@A@ k    `BB CDC r    EFE J    	GG HIH m    ����   ��I JKJ m    ����   ��K L��L m    ����   ����  F n      MNM 1    ��
�� 
bacCN 4   	 ��O
�� 
cwinO o    ���� 0 
windowname 
windowNameD PQP r    RSR m    ��
�� boovtrueS n      TUT 1    ��
�� 
hasSU 4    ��V
�� 
cwinV o    ���� 0 
windowname 
windowNameQ WXW r    -YZY n    &[\[ 4   # &��]
�� 
cobj] m   $ %���� \ J    #^^ _`_ m    ����  ` aba m    ���� b cdc m    ���� d efe m    ���� f ghg m    ���� h iji m     ���� ej k��k m     !�������  Z n      lml 1   * ,��
�� 
levVm 4   & *��n
�� 
cwinn o   ( )���� 0 
windowname 
windowNameX opo r   . 6qrq m   . /ss �tt  r n      uvu 1   3 5��
�� 
titlv 4   / 3��w
�� 
cwinw o   1 2���� 0 
windowname 
windowNamep xyx r   7 Dz{z m   7 8����  { n      |}| 1   ? C��
�� 
conT} n   8 ?~~ 4   < ?���
�� 
proI� m   = >����  4   8 <���
�� 
cwin� o   : ;���� 0 
windowname 
windowNamey ��� r   E R��� m   E F����  � n      ��� 1   M Q��
�� 
minW� n   F M��� 4   J M���
�� 
proI� m   K L���� � 4   F J���
�� 
cwin� o   H I���� 0 
windowname 
windowName� ���� r   S `��� o   S T�� 0 somemaxcount someMaxCount� n      ��� 1   [ _�~
�~ 
maxV� n   T [��� 4   X [�}�
�} 
proI� m   Y Z�|�| � 4   T X�{�
�{ 
cwin� o   V W�z�z 0 
windowname 
windowName��  A m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.0   ;/:Documents:Lablib:Utilities:Clone Project 3.0:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  9 ��� l     �y�x�w�y  �x  �w  � ��� l     �v���v  � ) # Increment progress bar subroutine.   � ��� F   I n c r e m e n t   p r o g r e s s   b a r   s u b r o u t i n e .� ��� i   # &��� I      �u��t�u $0 incrementprogbar incrementProgBar� ��� o      �s�s 0 
itemnumber 
itemNumber� ��� o      �r�r 0 somemaxcount someMaxCount� ��q� o      �p�p 0 
windowname 
windowName�q  �t  � O     &��� k    %�� ��� r    ��� b    ��� b    ��� b    ��� b    	��� b    ��� m    �� ���  P r o c e s s i n g  � o    �o�o 0 
itemnumber 
itemNumber� m    �� ���    o f  � o   	 
�n�n 0 somemaxcount someMaxCount� m    �� ���    -  � l   ��m�l� n    ��� 4    �k�
�k 
cobj� o    �j�j 0 
itemnumber 
itemNumber� o    �i�i 0 filelist fileList�m  �l  � n      ��� 1    �h
�h 
titl� 4    �g�
�g 
cwin� o    �f�f 0 
windowname 
windowName� ��e� r    %��� o    �d�d 0 
itemnumber 
itemNumber� n      ��� 1   " $�c
�c 
conT� n    "��� 4    "�b�
�b 
proI� m     !�a�a � 4    �`�
�` 
cwin� o    �_�_ 0 
windowname 
windowName�e  � m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.0   ;/:Documents:Lablib:Utilities:Clone Project 3.0:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  � ��� l     �^�]�\�^  �]  �\  � ��� l     �[���[  � %  Fade in a progress bar window.   � ��� >   F a d e   i n   a   p r o g r e s s   b a r   w i n d o w .� ��� i   ' *��� I      �Z��Y�Z 0 fadeinprogbar fadeinProgBar� ��X� o      �W�W 0 
windowname 
windowName�X  �Y  � O     O��� k    N�� ��� I   �V��U
�V .appScentnull���    obj � 4    �T�
�T 
cwin� o    �S�S 0 
windowname 
windowName�U  � ��� r    ��� m    �R�R  � n      ��� 1    �Q
�Q 
alpV� 4    �P�
�P 
cwin� o    �O�O 0 
windowname 
windowName� ��� r    ��� m    �N
�N boovtrue� n      ��� 1    �M
�M 
pvis� 4    �L�
�L 
cwin� o    �K�K 0 
windowname 
windowName� ��� r    "��� m     �� ?�������� o      �J�J 0 	fadevalue 	fadeValue� ��� Y   # @��I���H� k   - ;�� ��� r   - 5��� o   - .�G�G 0 	fadevalue 	fadeValue� n         1   2 4�F
�F 
alpV 4   . 2�E
�E 
cwin o   0 1�D�D 0 
windowname 
windowName� �C r   6 ; [   6 9 o   6 7�B�B 0 	fadevalue 	fadeValue m   7 8 ?������� o      �A�A 0 	fadevalue 	fadeValue�C  �I 0 i  � m   & '�@�@  � m   ' (�?�? 	�H  � 	�>	 I  A N�=

�= .coVSstaAnull���    obj 
 n   A H 4   E H�<
�< 
proI m   F G�;�;  4   A E�:
�: 
cwin o   C D�9�9 0 
windowname 
windowName �8�7
�8 
usTA m   I J�6
�6 boovtrue�7  �>  � m     �                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.0   ;/:Documents:Lablib:Utilities:Clone Project 3.0:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  �  l     �5�4�3�5  �4  �3    l     �2�2   &   Fade out a progress bar window.    � @   F a d e   o u t   a   p r o g r e s s   b a r   w i n d o w .  i   + . I      �1�0�1  0 fadeoutprogbar fadeoutProgBar �/ o      �.�. 0 
windowname 
windowName�/  �0   O     =  k    <!! "#" I   �-$%
�- .coVSstoTnull���    obj $ n    &'& 4    �,(
�, 
proI( m   	 
�+�+ ' 4    �*)
�* 
cwin) o    �)�) 0 
windowname 
windowName% �(*�'
�( 
usTA* m    �&
�& boovtrue�'  # +,+ r    -.- m    // ?�������. o      �%�% 0 	fadevalue 	fadeValue, 010 Y    32�$34�#2 k     .55 676 r     (898 o     !�"�" 0 	fadevalue 	fadeValue9 n      :;: 1   % '�!
�! 
alpV; 4   ! %� <
�  
cwin< o   # $�� 0 
windowname 
windowName7 =�= r   ) .>?> \   ) ,@A@ o   ) *�� 0 	fadevalue 	fadeValueA m   * +BB ?�������? o      �� 0 	fadevalue 	fadeValue�  �$ 0 i  3 m    �� 4 m    �� 	�#  1 C�C r   4 <DED m   4 5�
� boovfalsE n      FGF 1   9 ;�
� 
pvisG 4   5 9�H
� 
cwinH o   7 8�� 0 
windowname 
windowName�    m     II�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.0   ;/:Documents:Lablib:Utilities:Clone Project 3.0:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��   JKJ l     ����  �  �  K LML l     �NO�  N    Show progress bar window.   O �PP 4   S h o w   p r o g r e s s   b a r   w i n d o w .M QRQ i   / 2STS I      �U�� 0 showprogbar showProgBarU V�V o      �� 0 
windowname 
windowName�  �  T O     $WXW k    #YY Z[Z I   �\�
� .appScentnull���    obj \ 4    �
]
�
 
cwin] o    �	�	 0 
windowname 
windowName�  [ ^_^ r    `a` m    �
� boovtruea n      bcb 1    �
� 
pvisc 4    �d
� 
cwind o    �� 0 
windowname 
windowName_ e�e I   #�fg
� .coVSstaAnull���    obj f n    hih 4    �j
� 
proIj m    �� i 4    � k
�  
cwink o    ���� 0 
windowname 
windowNameg ��l��
�� 
usTAl m    ��
�� boovtrue��  �  X m     mm�                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.0   ;/:Documents:Lablib:Utilities:Clone Project 3.0:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  R non l     ��������  ��  ��  o pqp l     ��rs��  r    Hide progress bar window.   s �tt 4   H i d e   p r o g r e s s   b a r   w i n d o w .q uvu i   3 6wxw I      ��y���� 0 hideprogbar hideProgBary z��z o      ���� 0 
windowname 
windowName��  ��  x O     {|{ k    }} ~~ I   ����
�� .coVSstoTnull���    obj � n    ��� 4    ���
�� 
proI� m   	 
���� � 4    ���
�� 
cwin� o    ���� 0 
windowname 
windowName� �����
�� 
usTA� m    ��
�� boovtrue��   ���� r    ��� m    ��
�� boovfals� n      ��� 1    ��
�� 
pvis� 4    ���
�� 
cwin� o    ���� 0 
windowname 
windowName��  | m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.0   ;/:Documents:Lablib:Utilities:Clone Project 3.0:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  v ��� l     ��������  ��  ��  � ��� l     ������  � 7 1 Enable 'barber pole' behavior of a progress bar.   � ��� b   E n a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .� ��� i   7 :��� I      ������� 0 
barberpole 
barberPole� ���� o      ���� 0 
windowname 
windowName��  ��  � O     ��� r    ��� m    ��
�� boovtrue� n      ��� 1    ��
�� 
indR� n    ��� 4   	 ���
�� 
proI� m   
 ���� � 4    	���
�� 
cwin� o    ���� 0 
windowname 
windowName� m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.0   ;/:Documents:Lablib:Utilities:Clone Project 3.0:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  � ��� l     ��������  ��  ��  � ��� l     ������  � 8 2 Disable 'barber pole' behavior of a progress bar.   � ��� d   D i s a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .� ��� i   ; >��� I      �������  0 killbarberpole killBarberPole� ���� o      ���� 0 
windowname 
windowName��  ��  � O     ��� r    ��� m    ��
�� boovfals� n      ��� 1    ��
�� 
indR� n    ��� 4   	 ���
�� 
proI� m   
 ���� � 4    	���
�� 
cwin� o    ���� 0 
windowname 
windowName� m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.0   ;/:Documents:Lablib:Utilities:Clone Project 3.0:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  � ��� l     ��������  ��  ��  � ��� l     ������  �   Launch ProgBar.   � ���     L a u n c h   P r o g B a r .� ��� i   ? B��� I      �������� 0 startprogbar startProgBar��  ��  � O     
��� I   	������
�� .ascrnoop****      � ****��  ��  � m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.0   ;/:Documents:Lablib:Utilities:Clone Project 3.0:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  � ��� l     ��������  ��  ��  � ��� l     ������  �   Quit ProgBar.   � ���    Q u i t   P r o g B a r .� ��� i   C F��� I      �������� 0 stopprogbar stopProgBar��  ��  � O     
��� I   	������
�� .aevtquitnull��� ��� null��  ��  � m     ���                                                                                      @ alis    \  JHRM                           BD ����ProgBar.app                                                    ����            ����  
 cu             Clone Project 3.0   ;/:Documents:Lablib:Utilities:Clone Project 3.0:ProgBar.app/     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  � ��� l     ��������  ��  ��  � ��� l     ������  �  ////////////  User input   � ��� 0 / / / / / / / / / / / /     U s e r   i n p u t� ��� l     ��������  ��  ��  � ��� l   #���� r    #��� m    �� ���  R E S U B M I T� o      ���� 0 buttonpressed buttonPressed�   at least try one time   � ��� ,   a t   l e a s t   t r y   o n e   t i m e� ��� l  $������� V   $���� k   0��� ��� l  0 0������  � + %  User chooses project folder to copy   � ��� J     U s e r   c h o o s e s   p r o j e c t   f o l d e r   t o   c o p y� ��� r   0 C��� c   0 ?��� l  0 ;������ I  0 ;�����
�� .sysostflalis    ��� null��  � �� ��
�� 
prmp  m   4 7 � h T o   d u p l i c a t e :   c h o o s e   P l u g i n   p r o j e c t   t o   u s e   a s   s o u r c e��  ��  ��  � m   ; >��
�� 
alis� o      ���� 0 	thefolder 	theFolder�  r   D U n   D O 1   K O��
�� 
pnam l  D K	����	 I  D K��
��
�� .sysonfo4asfe        file
 o   D G���� 0 	thefolder 	theFolder��  ��  ��   o      ����  0 oldprojectname oldProjectName  l  V V��������  ��  ��    l  V V����   s m this extracts the path to folder in which the duplicated project folder resides and gives it the name myHome    � �   t h i s   e x t r a c t s   t h e   p a t h   t o   f o l d e r   i n   w h i c h   t h e   d u p l i c a t e d   p r o j e c t   f o l d e r   r e s i d e s   a n d   g i v e s   i t   t h e   n a m e   m y H o m e  l  V V����   1 + POSIX format because used by shell scripts    � V   P O S I X   f o r m a t   b e c a u s e   u s e d   b y   s h e l l   s c r i p t s  Q   V � k   Y �  r   Y d  n  Y `!"! 1   \ `��
�� 
txdl" 1   Y \��
�� 
ascr  o      ���� 0 olddelimiter oldDelimiter #$# r   e t%&% c   e p'(' n   e l)*) 1   h l��
�� 
psxp* o   e h���� 0 	thefolder 	theFolder( m   l o��
�� 
TEXT& o      ���� 0 myhome myHome$ +,+ r   u �-.- m   u x// �00  /. n     121 1   { ��
�� 
txdl2 1   x {��
�� 
ascr, 343 r   � �565 I  � ���7��
�� .corecnte****       ****7 l  � �8����8 n   � �9:9 2   � ���
�� 
citm: o   � ����� 0 myhome myHome��  ��  ��  6 o      ���� 0 totl  4 ;<; l  � �=>?= r   � �@A@ \   � �BCB o   � ����� 0 totl  C m   � ����� A o      ���� 
0 ending  > + % remove current folder name from path   ? �DD J   r e m o v e   c u r r e n t   f o l d e r   n a m e   f r o m   p a t h< EFE r   � �GHG b   � �IJI l  � �K����K c   � �LML n   � �NON 7  � ���PQ
�� 
citmP m   � ����� Q o   � ����� 
0 ending  O o   � ��� 0 myhome myHomeM m   � ��~
�~ 
TEXT��  ��  J m   � �RR �SS  /H o      �}�} 0 myhome myHomeF T�|T r   � �UVU o   � ��{�{ 0 olddelimiter oldDelimiterV n     WXW 1   � ��z
�z 
txdlX 1   � ��y
�y 
ascr�|   R      �xY�w
�x .ascrerr ****      � ****Y m      ZZ �[[ ~ e r r o r   o c c u r r e d   a t t e m p t i n g   t o   e x t r a c t   p a t h   t o   n e w   p r o j e c t   f o l d e r�w   r   � �\]\ o   � ��v�v 0 olddelimiter oldDelimiter] n     ^_^ 1   � ��u
�u 
txdl_ 1   � ��t
�t 
ascr `a` l  � ��s�r�q�s  �r  �q  a bcb l  � ��pde�p  d ? 9 User chooses the name they wish to give the project copy   e �ff r   U s e r   c h o o s e s   t h e   n a m e   t h e y   w i s h   t o   g i v e   t h e   p r o j e c t   c o p yc ghg I  � ��oij
�o .sysodlogaskr        TEXTi m   � �kk �ll & N a m e   o f   n e w   p l u g i n ?j �nmn
�n 
dtxtm m   � �oo �pp  n e w P l u g i nn �mqr
�m 
btnsq J   � �ss t�lt m   � �uu �vv    O K�l  r �kw�j
�k 
dfltw m   � ��i�i �j  h xyx s   �z{z c   � �|}| l  � �~�h�g~ 1   � ��f
�f 
rslt�h  �g  } m   � ��e
�e 
list{ J       ��� o      �d�d 0 button_pressed  � ��c� o      �b�b 0 text_returned  �c  y ��� r   ��� c  ��� o  �a�a 0 text_returned  � m  �`
�` 
TEXT� o      �_�_  0 newprojectname newProjectName� ��� l !>���� r  !>��� l !:��^�]� I !:�\�[��\ 0 searchreplace searchReplace�[  � �Z��
�Z 
into� o  %(�Y�Y  0 newprojectname newProjectName� �X��
�X 
at  � m  +.�� ���   � �W��V�W 0 replacestring replaceString� m  14�� ���  �V  �^  �]  � o      �U�U  0 newprojectname newProjectName�   remove all spaces   � ��� $   r e m o v e   a l l   s p a c e s� ��� l ??�T�S�R�T  �S  �R  � ��� l ??�Q�P�O�Q  �P  �O  � ��� l ??�N���N  � ? 9 User provides the current prefix of the original project   � ��� r   U s e r   p r o v i d e s   t h e   c u r r e n t   p r e f i x   o f   t h e   o r i g i n a l   p r o j e c t� ��� I ?d�M��
�M .sysodlogaskr        TEXT� l ?L��L�K� b  ?L��� b  ?H��� m  ?B�� ��� > W h a t   i s   t h e   c u r r e n t   p r e f i x   f o r  � o  BG�J�J  0 oldprojectname oldProjectName� m  HK�� ���    ?�L  �K  � �I��
�I 
dtxt� m  OR�� ���  F T� �H��
�H 
btns� J  UZ�� ��G� m  UX�� ���  O K�G  � �F��E
�F 
dflt� m  ]^�D�D �E  � ��� s  e���� c  el��� l eh��C�B� 1  eh�A
�A 
rslt�C  �B  � m  hk�@
�@ 
list� J      �� ��� o      �?�? 0 button_pressed  � ��>� o      �=�= 0 text_returned  �>  � ��� r  ����� c  ����� o  ���<�< 0 text_returned  � m  ���;
�; 
TEXT� o      �:�: 0 
old_prefix  � ��� l ������ r  ����� l ����9�8� I ���7�6��7 0 searchreplace searchReplace�6  � �5��
�5 
into� o  ���4�4 0 
old_prefix  � �3��
�3 
at  � m  ���� ���   � �2��1�2 0 replacestring replaceString� m  ���� ���  �1  �9  �8  � o      �0�0 0 
old_prefix  �   remove all spaces   � ��� $   r e m o v e   a l l   s p a c e s� ��� r  ����� I  ���/��.�/ 0 upcase upCase� ��-� o  ���,�, 0 
old_prefix  �-  �.  � o      �+�+ 0 
old_prefix  � ��� r  ����� [  ����� l ����*�)� I ���(��'
�( .corecnte****       ****� o  ���&�& 0 
old_prefix  �'  �*  �)  � m  ���%�% � o      �$�$ 0 kernel_beginning  � ��� Z  �����#�"� E  ����� o  ���!�!  0 myreservedlist myReservedList� o  ��� �  0 
old_prefix  � k  ���� ��� I �����
� .sysobeepnull��� ��� long�  �  � ��� I �����
� .sysodlogaskr        TEXT� m  ���� ��� W A R N I N G   - -   Y o u r   o r i g i n a l   p r e f i x   i s   o n   t h e   r e s e r v e d   l i s t .   U s a g e   o f   t h i s   p r e f i x   i s   n o t   a l l o w e d .   T h e   p r o j e c t   i s   n o t   c l o n a b l e .   E x i t   n o w .� ���
� 
disp� m  ���
� stic    �  � ��� l ��   L  ����     abort program    �    a b o r t   p r o g r a m�  �#  �"  �  l ������  �  �    l ���	�   4 . User chooses new prefix to replace old prefix   	 �

 \   U s e r   c h o o s e s   n e w   p r e f i x   t o   r e p l a c e   o l d   p r e f i x  T  �� k  ��  I ��
� .sysodlogaskr        TEXT l � �� b  �  b  �� m  �� � 6 W h a t   i s   t h e   n e w   p r e f i x   f o r   o  ����  0 newprojectname newProjectName m  �� �    ?  �  �   �
� 
dtxt m   �   � !
� 
btns  J  	"" #�# m  	$$ �%%  O K�  ! �&�

� 
dflt& m  �	�	 �
   '(' s  9)*) c   +,+ l -��- 1  �
� 
rslt�  �  , m  �
� 
list* J      .. /0/ o      �� 0 button_pressed  0 1�1 o      �� 0 text_returned  �  ( 232 r  :E454 c  :A676 o  :=�� 0 text_returned  7 m  =@� 
�  
TEXT5 o      ���� 0 
new_prefix  3 8��8 Q  F�9:;9 k  I�<< =>= l IP?@A? r  IPBCB m  IL���� 0C o      ���� 0 n  @   zero   A �DD 
   z e r o> EFE U  Q�GHG k  Z�II JKJ Z  Z�LM����L ?  ZsNON l ZqP����P I Zq����Q
�� .sysooffslong    ��� null��  Q ��RS
�� 
psofR l ^eT����T I ^e��U��
�� .sysontocTEXT       shorU o  ^a���� 0 n  ��  ��  ��  S ��V��
�� 
psinV o  hk���� 0 
new_prefix  ��  ��  ��  O m  qr����  M R  v|��W��
�� .ascrerr ****      � ****W m  x{XX �YY L N u m b e r s   a r e   n o t   a l l o w e d   f o r   t h e   p r e f i x��  ��  ��  K Z��Z r  ��[\[ [  ��]^] o  ������ 0 n  ^ m  ������ \ o      ���� 0 n  ��  H m  TW���� 
F _`_ l ��abca r  ��ded l ��f����f I ������g�� 0 searchreplace searchReplace��  g ��hi
�� 
intoh o  ������ 0 
new_prefix  i ��jk
�� 
at  j m  ��ll �mm   k ��n���� 0 replacestring replaceStringn m  ��oo �pp  ��  ��  ��  e o      ���� 0 
new_prefix  b   remove all spaces   c �qq $   r e m o v e   a l l   s p a c e s` rsr r  ��tut I  ����v���� 0 upcase upCasev w��w o  ������ 0 
new_prefix  ��  ��  u o      ���� 0 
new_prefix  s x��x Z  ��yz��{y E  ��|}| o  ������  0 myreservedlist myReservedList} o  ������ 0 
new_prefix  z k  ��~~ � I ��������
�� .sysobeepnull��� ��� long��  ��  � ���� I ������
�� .sysodlogaskr        TEXT� m  ���� ���  W A R N I N G !   - -   Y o u r   n e w   p r e f i x   i s   o n   t h e   r e s e r v e d   l i s t .   U s a g e   o f   t h i s   p r e f i x   i s   n o t   a l l o w e d .   A d d i n g   X ,   Y   o r   Z   t o   t h e   b e g i n n i n g   w o u l d   b e   a c c e p t a b l e .� �����
�� 
disp� m  ����
�� stic    ��  ��  ��  {  S  ����  : R      ������
�� .ascrerr ****      � ****��  ��  ; I ������
�� .sysodlogaskr        TEXT� m  ���� ��� L N u m b e r s   a r e   n o t   a l l o w e d   f o r   t h e   p r e f i x� �����
�� 
disp� m  ����
�� stic    ��  ��   ��� l ����������  ��  ��  � ��� l ����������  ��  ��  � ��� l ��������  � / ) end of setup  //////////////////////////   � ��� R   e n d   o f   s e t u p     / / / / / / / / / / / / / / / / / / / / / / / / / /� ��� l ����������  ��  ��  � ��� I �6����
�� .sysodlogaskr        TEXT� l ������� b  ���� b  ���� b  ���� b  ���� b  ���� b  ���� b  � ��� m  ���� ��� ^ T h i s   i s   w h a t   w i l l   b e   u s e d : 
 o r i g i n a l   p r o j e c t : 	 	  � o  ������  0 oldprojectname oldProjectName� m   �� ���   
 n e w   p r o j e c t : 	 	  � o  ����  0 newprojectname newProjectName� m  �� ��� & 
 o r i g i n a l   p r e f i x : 	 	� o  ���� 0 
old_prefix  � m  �� ���  
 n e w   p r e f i x : 	 	� o  ���� 0 
new_prefix  ��  ��  � ����
�� 
btns� J  &�� ��� m  �� ���  O K� ��� m  !�� ���  R E S U B M I T� ���� m  !$�� ���  E X I T��  � ����
�� 
dflt� m  )*���� � �����
�� 
disp� m  -0��
�� stic   ��  � ��� s  7K��� c  7>��� l 7:������ 1  7:��
�� 
rslt��  ��  � m  :=��
�� 
list� J      �� ���� o      ���� 0 buttonpressed buttonPressed��  � ��� l LL��������  ��  ��  � ��� Z  L�������� > LS��� o  LO���� 0 buttonpressed buttonPressed� m  OR�� ���  E X I T� l V����� Z  V������� = V]��� o  VY����  0 newprojectname newProjectName� m  Y\�� ���  � k  `u�� ��� r  `g��� m  `c�� ���  R E S U B M I T� o      ���� 0 buttonpressed buttonPressed� ���� I hu����
�� .sysodlogaskr        TEXT� m  hk�� ��� � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .� �����
�� 
disp� m  nq��
�� stic    ��  ��  � ��� = x��� o  x{���� 0 
old_prefix  � m  {~�� ���  � ��� k  ���� ��� r  ����� m  ���� ���  R E S U B M I T� o      ���� 0 buttonpressed buttonPressed� ���� I ������
�� .sysodlogaskr        TEXT� m  ���� �   � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .� ����
�� 
disp m  ����
�� stic    ��  ��  �  = �� o  ������ 0 
new_prefix   m  �� �   �� k  ��		 

 r  �� m  �� �  R E S U B M I T o      ���� 0 buttonpressed buttonPressed �� I ����
�� .sysodlogaskr        TEXT m  �� � � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s . ����
�� 
disp m  ����
�� stic    ��  ��  ��  ��  � ; 5 this checks to see if any answers were a null string   � � j   t h i s   c h e c k s   t o   s e e   i f   a n y   a n s w e r s   w e r e   a   n u l l   s t r i n g��  ��  � �� l ����������  ��  ��  ��  � =  ( / o   ( +���� 0 buttonpressed buttonPressed m   + . �  R E S U B M I T��  ��  �  l     ��������  ��  ��    l �� ��~  Z  ��!"�}�|! = ��#$# o  ���{�{ 0 buttonpressed buttonPressed$ m  ��%% �&&  E X I T" l ��'()' L  ���z�z  ( $  abort program by user request   ) �** <   a b o r t   p r o g r a m   b y   u s e r   r e q u e s t�}  �|  �  �~   +,+ l     �y�x�w�y  �x  �w  , -.- l     �v/0�v  /  ////// end of User Input   0 �11 0 / / / / / /   e n d   o f   U s e r   I n p u t. 232 l     �u�t�s�u  �t  �s  3 454 l     �r�q�p�r  �q  �p  5 676 l     �o89�o  8 / ) Duplicate original Xcode project folder    9 �:: R   D u p l i c a t e   o r i g i n a l   X c o d e   p r o j e c t   f o l d e r  7 ;<; l ��=�n�m= O  ��>?> r  ��@A@ I ���lB�k
�l .coreclon****      � ****B o  ���j�j 0 	thefolder 	theFolder�k  A o      �i�i 0 	newfolder 	newFolder? m  ��CC�                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �n  �m  < DED l     �h�g�f�h  �g  �f  E FGF l     �eHI�e  H = 7 set POSIX path for duplicated Folder for shell scripts   I �JJ n   s e t   P O S I X   p a t h   f o r   d u p l i c a t e d   F o l d e r   f o r   s h e l l   s c r i p t sG KLK l �M�d�cM r  �NON c  ��PQP b  ��RSR b  ��TUT o  ���b�b 0 myhome myHomeU o  ���a�a  0 oldprojectname oldProjectNameS m  ��VV �WW    c o p y /Q m  ���`
�` 
TEXTO o      �_�_ 0 mypath myPath�d  �c  L XYX l     �^�]�\�^  �]  �\  Y Z[Z l     �[\]�[  \   create new project   ] �^^ &   c r e a t e   n e w   p r o j e c t[ _`_ l     �Zab�Z  a ) # Launch ProgBar for the first time.   b �cc F   L a u n c h   P r o g B a r   f o r   t h e   f i r s t   t i m e .` ded l 
f�Y�Xf n  
ghg I  
�W�V�U�W 0 startprogbar startProgBar�V  �U  h  f  �Y  �X  e iji l     �T�S�R�T  �S  �R  j klk l 	�mnom O  	�pqp k  	�rr sts l �Q�P�O�Q  �P  �O  t uvu l �Nwx�N  w U O clean out duplicated project build folder before making list of project items    x �yy �   c l e a n   o u t   d u p l i c a t e d   p r o j e c t   b u i l d   f o l d e r   b e f o r e   m a k i n g   l i s t   o f   p r o j e c t   i t e m s  v z{z r  |}| c  ~~ o  �M�M 0 	newfolder 	newFolder m  �L
�L 
ctxt} o      �K�K 0 mybuildpath myBuildPath{ ��� r  ,��� c  (��� b  $��� o   �J�J 0 mybuildpath myBuildPath� m   #�� ��� 
 b u i l d� m  $'�I
�I 
alis� o      �H�H 0 mybuildpath myBuildPath� ��� Z  -M���G�F� > -;��� l -8��E�D� I -8�C��
�C .earslfdrutxt  @    file� o  -0�B�B 0 mybuildpath myBuildPath� �A��@
�A 
lfiv� m  34�?
�? boovfals�@  �E  �D  � J  8:�>�>  � I >I�=��<
�= .coredelonull���     obj � n  >E��� 2 AE�;
�; 
cobj� o  >A�:�: 0 mybuildpath myBuildPath�<  �G  �F  � ��� l NN�9�8�7�9  �8  �7  � ��� l NN�6���6  � I C Make a list of all file names in project folder and the subfolders   � ��� �   M a k e   a   l i s t   o f   a l l   f i l e   n a m e s   i n   p r o j e c t   f o l d e r   a n d   t h e   s u b f o l d e r s� ��� r  No��� b  Nk��� l NZ��5�4� e  NZ�� n  NZ��� 1  UY�3
�3 
pnam� n NU��� 2  QU�2
�2 
file� o  NQ�1�1 0 	newfolder 	newFolder�5  �4  � l Zj��0�/� e  Zj�� n  Zj��� 1  ei�.
�. 
pnam� n  Ze��� 2  ae�-
�- 
file� n Za��� 2  ]a�,
�, 
cfol� o  Z]�+�+ 0 	newfolder 	newFolder�0  �/  � o      �*�* 0 filelist fileList� ��� I pw�)��(
�) .corecnte****       ****� 1  ps�'
�' 
rslt�(  � ��� l x���� r  x��� 1  x{�&
�& 
rslt� o      �%�% 0 numfiles numFiles� 2 , Count of all files in folder and subfolders   � ��� X   C o u n t   o f   a l l   f i l e s   i n   f o l d e r   a n d   s u b f o l d e r s� ��� l ������ n  ����� I  ���$��#�$  0 prepareprogbar prepareProgBar� ��� o  ���"�" 0 numfiles numFiles� ��!� m  ��� �  �!  �#  �  f  ���   Prepare Progress Bar   � ��� *   P r e p a r e   P r o g r e s s   B a r� ��� l ������ n  ����� I  ������ 0 fadeinprogbar fadeinProgBar� ��� m  ���� �  �  �  f  ��� 2 , Open the desired Progress Bar window style.   � ��� X   O p e n   t h e   d e s i r e d   P r o g r e s s   B a r   w i n d o w   s t y l e .� ��� l ������  �  �  � ��� l ������  � 8 2 rename prefixes and file names of project files     � ��� d   r e n a m e   p r e f i x e s   a n d   f i l e   n a m e s   o f   p r o j e c t   f i l e s    � ��� Y  �	������� k  �	��� ��� l ������ n  ����� I  ������ $0 incrementprogbar incrementProgBar� ��� o  ���� 0 n  � ��� o  ���� 0 numfiles numFiles� ��� m  ���� �  �  �  f  ��� !  Increment the progress bar   � ��� 6   I n c r e m e n t   t h e   p r o g r e s s   b a r� ��� l ������ r  ����� l ������ e  ���� n  ����� 4  ����
� 
cobj� o  ���� 0 n  � o  ���� 0 filelist fileList�  �  � o      �
�
 0 currentfile currentFile� #  Get the next file to process   � ��� :   G e t   t h e   n e x t   f i l e   t o   p r o c e s s� ��	� Z  �	������ C  ��� � o  ���� 0 currentfile currentFile  o  ���� 0 
old_prefix  � l �� k  ��  Z  ���	 H  ��

 C  �� o  ���� 0 currentfile currentFile o  ����  0 oldprojectname oldProjectName l �n k  �n  l ����   8 2 extract filename without prefix from current file    � d   e x t r a c t   f i l e n a m e   w i t h o u t   p r e f i x   f r o m   c u r r e n t   f i l e  r  �� m  �� �   o      �� 0 filename_kernel    Y  ���  �� r  ��!"! b  ��#$# o  ������ 0 filename_kernel  $ l ��%����% n  ��&'& 4  ����(
�� 
cobj( o  ������ 0 n  ' o  ������ 0 currentfile currentFile��  ��  " o      ���� 0 filename_kernel  �  0 n   o  ������ 0 kernel_beginning    l ��)����) I ����*��
�� .corecnte****       ***** o  ������ 0 currentfile currentFile��  ��  ��  ��   +,+ l ����-.��  - 5 / prepend new prefix to filename of current file   . �// ^   p r e p e n d   n e w   p r e f i x   t o   f i l e n a m e   o f   c u r r e n t   f i l e, 010 O �232 r  454 l 6����6 I ��7��
�� .coredoexnull���     ****7 l 8����8 n  9:9 4  ��;
�� 
file; o  	���� 0 currentfile currentFile: o  ���� 0 	newfolder 	newFolder��  ��  ��  ��  ��  5 o      ���� "0 myfileexisthere myFileExistHere3 m  � <<�                                                                                  sevs  alis    L  JHRM                           BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p  
  J H R M  -System/Library/CoreServices/System Events.app   / ��  1 =��= Z  n>?��@> o  ���� "0 myfileexisthere myFileExistHere? k  LAA BCB n 5DED I  5��F���� &0 replacetextinfile replaceTextInFileF GHG o  !���� 0 currentfile currentFileH IJI o  !&����  0 oldprojectname oldProjectNameJ KLK o  &)����  0 newprojectname newProjectNameL MNM o  ),���� 0 
old_prefix  N O��O o  ,/���� 0 
new_prefix  ��  ��  E  f  C P��P r  6LQRQ l 6=S����S b  6=TUT o  69���� 0 
new_prefix  U o  9<���� 0 filename_kernel  ��  ��  R n      VWV 1  GK��
�� 
pnamW n  =GXYX 4  @G��Z
�� 
docfZ o  CF���� 0 currentfile currentFileY o  =@���� 0 	newfolder 	newFolder��  ��  @ l On[\][ r  On^_^ l OV`����` b  OVaba o  OR���� 0 
new_prefix  b o  RU���� 0 filename_kernel  ��  ��  _ n      cdc 1  im��
�� 
pnamd n  Viefe 4  bi��g
�� 
docfg o  eh���� 0 currentfile currentFilef n  Vbhih 4  Yb��j
�� 
cfolj o  \a���� 0 	nibfolder 	nibFolderi o  VY���� 0 	newfolder 	newFolder\ #  it must be in the nib Folder   ] �kk :   i t   m u s t   b e   i n   t h e   n i b   F o l d e r��   < 6 If user did not start project name with the prefix...    �ll l   I f   u s e r   d i d   n o t   s t a r t   p r o j e c t   n a m e   w i t h   t h e   p r e f i x . . .�  	 l q�mnom Z  q�pqr��p D  qxsts o  qt���� 0 currentfile currentFilet m  twuu �vv  . x c o d e p r o jq l {�wxyw r  {�z{z b  {�|}| o  {~����  0 newprojectname newProjectName} m  ~�~~ �  . x c o d e p r o j{ n      ��� 1  ����
�� 
pnam� n  ����� 4  �����
�� 
docf� o  ������ 0 currentfile currentFile� o  ������ 0 	newfolder 	newFolderx A ; non-special case were project name does not include prefix   y ��� v   n o n - s p e c i a l   c a s e   w e r e   p r o j e c t   n a m e   d o e s   n o t   i n c l u d e   p r e f i xr ��� D  ����� o  ������ 0 currentfile currentFile� m  ���� ���  . p c h� ��� r  ����� b  ����� o  ������  0 newprojectname newProjectName� m  ���� ���  _ P r e f i x . p c h� n      ��� 1  ����
�� 
pnam� n  ����� 4  �����
�� 
docf� o  ������ 0 currentfile currentFile� o  ������ 0 	newfolder 	newFolder� ��� D  ����� o  ������ 0 currentfile currentFile� m  ���� ���  . m� ��� k  ��� ��� n ����� I  ��������� &0 replacetextinfile replaceTextInFile� ��� o  ������ 0 currentfile currentFile� ��� o  ������  0 oldprojectname oldProjectName� ��� o  ������  0 newprojectname newProjectName� ��� o  ������ 0 
old_prefix  � ���� o  ������ 0 
new_prefix  ��  ��  �  f  ��� ���� Z  �������� = ����� o  ������ 0 currentfile currentFile� l �������� b  ����� o  ������  0 oldprojectname oldProjectName� m  ���� ���  . m��  ��  � l � ���� r  � ��� b  ����� o  ������  0 newprojectname newProjectName� m  ���� ���  . m� n      ��� 1  ����
�� 
pnam� n  ����� 4  �����
�� 
docf� o  ������ 0 currentfile currentFile� o  ������ 0 	newfolder 	newFolder�   should only happen once   � ��� 0   s h o u l d   o n l y   h a p p e n   o n c e��  ��  ��  � ��� D  ��� o  
���� 0 currentfile currentFile� m  
�� ���  . h� ��� k  }�� ��� n )��� I  )������� &0 replacetextinfile replaceTextInFile� ��� o  ���� 0 currentfile currentFile� ��� o  ����  0 oldprojectname oldProjectName� ��� o  ����  0 newprojectname newProjectName� ��� o   ���� 0 
old_prefix  � ���� o   #���� 0 
new_prefix  ��  ��  �  f  � ���� Z  *}������ = *7��� o  *-���� 0 currentfile currentFile� l -6������ b  -6��� o  -2����  0 oldprojectname oldProjectName� m  25�� ���  . h��  ��  � l :P���� r  :P��� b  :A��� o  :=����  0 newprojectname newProjectName� m  =@�� ���  . h� n      ��� 1  KO��
�� 
pnam� n  AK��� 4  DK���
�� 
docf� o  GJ���� 0 currentfile currentFile� o  AD���� 0 	newfolder 	newFolder�    should only happen once		   � ��� 4   s h o u l d   o n l y   h a p p e n   o n c e 	 	� ��� = S`��� o  SV���� 0 currentfile currentFile� l V_������ b  V_�	 � o  V[����  0 oldprojectname oldProjectName	  m  [^		 �		  _ P r e f i x . h��  ��  � 	��	 l cy				 r  cy			 b  cj			
		 o  cf����  0 newprojectname newProjectName	
 m  fi		 �		  _ P r e f i x . h	 n      			 1  tx��
�� 
pnam	 n  jt			 4  mt��	
�� 
docf	 o  ps���� 0 currentfile currentFile	 o  jm���� 0 	newfolder 	newFolder	   should only happen once	   	 �		 2   s h o u l d   o n l y   h a p p e n   o n c e 	��  ��  ��  � 			 =  ��			 o  ������ 0 currentfile currentFile	 b  ��			 o  ������  0 oldprojectname oldProjectName	 m  ��		 �		  . n i b	 			 k  ��		 			 r  ��	 	!	  b  ��	"	#	" o  ������  0 newprojectname newProjectName	# m  ��	$	$ �	%	%  . n i b	! n      	&	'	& 1  ����
�� 
pnam	' n  ��	(	)	( 4  ����	*
�� 
docf	* o  ������ 0 currentfile currentFile	) n  ��	+	,	+ 4  ����	-
�� 
cfol	- o  ������ 0 	nibfolder 	nibFolder	, o  ������ 0 	newfolder 	newFolder	 	.�	. l ���~	/	0�~  	/       	0 �	1	1     �  	 	2	3	2 D  ��	4	5	4 o  ���}�} 0 currentfile currentFile	5 m  ��	6	6 �	7	7  . p l i s t	3 	8�|	8 k  ��	9	9 	:	;	: r  ��	<	=	< m  ��	>	> �	?	?  . p l i s t	= o      �{�{ 0 
filesuffix 
fileSuffix	; 	@	A	@ n ��	B	C	B I  ���z	D�y�z &0 replacetextinfile replaceTextInFile	D 	E	F	E o  ���x�x 0 currentfile currentFile	F 	G	H	G o  ���w�w  0 oldprojectname oldProjectName	H 	I	J	I o  ���v�v  0 newprojectname newProjectName	J 	K	L	K o  ���u�u 0 
old_prefix  	L 	M�t	M o  ���s�s 0 
new_prefix  �t  �y  	C  f  ��	A 	N	O	N r  ��	P	Q	P I ���r	R�q
�r .sysoctonshor       TEXT	R l ��	S�p�o	S n  ��	T	U	T 4 ���n	V
�n 
cobj	V m  ���m�m 	U o  ���l�l  0 oldprojectname oldProjectName�p  �o  �q  	Q o      �k�k 0 testchar testChar	O 	W	X	W Z  �U	Y	Z�j�i	Y F  �		[	\	[ @  ��	]	^	] o  ���h�h 0 testchar testChar	^ m  ���g�g A	\ B  �	_	`	_ o  ��f�f 0 testchar testChar	` m  �e�e Z	Z l Q	a	b	c	a k  Q	d	d 	e	f	e r  	g	h	g m  	i	i �	j	j  	h o      �d�d 
0 locase  	f 	k	l	k Y  =	m�c	n	o�b	m r  &8	p	q	p b  &4	r	s	r o  &)�a�a 
0 locase  	s l )3	t�`�_	t n  )3	u	v	u 4  .3�^	w
�^ 
cobj	w o  12�]�] 0 n  	v o  ).�\�\  0 oldprojectname oldProjectName�`  �_  	q o      �[�[ 
0 locase  �c 0 n  	n m  �Z�Z 	o l !	x�Y�X	x I !�W	y�V
�W .corecnte****       ****	y o  �U�U  0 oldprojectname oldProjectName�V  �Y  �X  �b  	l 	z�T	z r  >Q	{	|	{ b  >M	}	~	} l >I	�S�R	 I >I�Q	��P
�Q .sysontocTEXT       shor	� l >E	��O�N	� [  >E	�	�	� o  >A�M�M 0 testchar testChar	� m  AD�L�L  �O  �N  �P  �S  �R  	~ o  IL�K�K 
0 locase  	| o      �J�J 
0 locase  �T  	b   is it uppercase ?   	c �	�	� $   i s   i t   u p p e r c a s e   ?�j  �i  	X 	�	�	� l Vd	�	�	�	� n Vd	�	�	� I  Wd�I	��H�I &0 simplereplacetext simpleReplaceText	� 	�	�	� o  WZ�G�G 0 currentfile currentFile	� 	�	�	� o  Z]�F�F 
0 locase  	� 	��E	� o  ]`�D�D  0 newprojectname newProjectName�E  �H  	�  f  VW	� 7 1 catch any lowercase instances of project name 		   	� �	�	� b   c a t c h   a n y   l o w e r c a s e   i n s t a n c e s   o f   p r o j e c t   n a m e   	 		� 	�	�	� l ee�C	�	��C  	� ; 5 rename only .plist files containing the projectname    	� �	�	� j   r e n a m e   o n l y   . p l i s t   f i l e s   c o n t a i n i n g   t h e   p r o j e c t n a m e  	� 	��B	� r  e�	�	�	� l e�	��A�@	� I e��?	�	��? 0 searchreplace searchReplace	�  f  ef	� �>	�	�
�> 
into	� o  il�=�= 0 currentfile currentFile	� �<	�	�
�< 
at  	� o  ot�;�;  0 oldprojectname oldProjectName	� �:	��9�: 0 replacestring replaceString	� o  wz�8�8  0 newprojectname newProjectName�9  �A  �@  	� n      	�	�	� 1  ���7
�7 
pnam	� n  ��	�	�	� 4  ���6	�
�6 
docf	� o  ���5�5 0 currentfile currentFile	� o  ���4�4 0 	newfolder 	newFolder�B  �|  ��  n � � SPECIAL CASE! project name includes original prefix - only check file once so need code redundancy here -- future create function instead?   o �	�	�   S P E C I A L   C A S E !   p r o j e c t   n a m e   i n c l u d e s   o r i g i n a l   p r e f i x   -   o n l y   c h e c k   f i l e   o n c e   s o   n e e d   c o d e   r e d u n d a n c y   h e r e   - -   f u t u r e   c r e a t e   f u n c t i o n   i n s t e a d ? 	��3	� l ���2�1�0�2  �1  �0  �3   , & If its name has got the old prefix...    �	�	� L   I f   i t s   n a m e   h a s   g o t   t h e   o l d   p r e f i x . . .�  � l �	�	�	�	�	� Z  �	�	�	�	��/	� D  ��	�	�	� o  ���.�. 0 currentfile currentFile	� m  ��	�	� �	�	�  . x c o d e p r o j	� l ��	�	�	�	� r  ��	�	�	� b  ��	�	�	� o  ���-�-  0 newprojectname newProjectName	� m  ��	�	� �	�	�  . x c o d e p r o j	� n      	�	�	� 1  ���,
�, 
pnam	� n  ��	�	�	� 4  ���+	�
�+ 
docf	� o  ���*�* 0 currentfile currentFile	� o  ���)�) 0 	newfolder 	newFolder	� B < non-special case where project name does not include prefix   	� �	�	� x   n o n - s p e c i a l   c a s e   w h e r e   p r o j e c t   n a m e   d o e s   n o t   i n c l u d e   p r e f i x	� 	�	�	� D  ��	�	�	� o  ���(�( 0 currentfile currentFile	� m  ��	�	� �	�	�  . p c h	� 	�	�	� r  ��	�	�	� b  ��	�	�	� o  ���'�'  0 newprojectname newProjectName	� m  ��	�	� �	�	�  _ P r e f i x . p c h	� n      	�	�	� 1  ���&
�& 
pnam	� n  ��	�	�	� 4  ���%	�
�% 
docf	� o  ���$�$ 0 currentfile currentFile	� o  ���#�# 0 	newfolder 	newFolder	� 	�	�	� D  ��	�	�	� o  ���"�" 0 currentfile currentFile	� m  ��	�	� �	�	�  . m	� 	�	�	� k  �+	�	� 	�	�	� n � 	�	�	� I  � �!	�� �! &0 replacetextinfile replaceTextInFile	� 	�	�	� o  ���� 0 currentfile currentFile	� 	�	�	� o  ����  0 oldprojectname oldProjectName	� 	�	�	� o  ����  0 newprojectname newProjectName	� 	�	�	� o  ���� 0 
old_prefix  	� 	��	� o  ���� 0 
new_prefix  �  �   	�  f  ��	� 	��	� Z  +	�	���	� = 	�	�	� o  �� 0 currentfile currentFile	� l 	���	� b  	�	�	� o  	��  0 oldprojectname oldProjectName	� m  		�	� �	�	�  . m�  �  	� l '	�	�	�	� r  '	�	�	� b  	�	�	� o  ��  0 newprojectname newProjectName	� m  	�	� �
 
   . m	� n      


 1  "&�
� 
pnam
 n  "


 4  "�

� 
docf
 o  !�� 0 currentfile currentFile
 o  �� 0 	newfolder 	newFolder	�   should only happen once   	� �

 0   s h o u l d   o n l y   h a p p e n   o n c e�  �  �  	� 


 D  .5
	


	 o  .1�� 0 currentfile currentFile

 m  14

 �

  . h
 


 k  8�

 


 n 8P


 I  9P�
�� &0 replacetextinfile replaceTextInFile
 


 o  9<�
�
 0 currentfile currentFile
 


 o  <A�	�	  0 oldprojectname oldProjectName
 


 o  AD��  0 newprojectname newProjectName
 


 o  DG�� 0 
old_prefix  
 
�
 o  GJ�� 0 
new_prefix  �  �  
  f  89
 
�
 Z  Q�

 
!�
 = Q^
"
#
" o  QT�� 0 currentfile currentFile
# l T]
$�� 
$ b  T]
%
&
% o  TY����  0 oldprojectname oldProjectName
& m  Y\
'
' �
(
(  . h�  �   
  l aw
)
*
+
) r  aw
,
-
, b  ah
.
/
. o  ad����  0 newprojectname newProjectName
/ m  dg
0
0 �
1
1  . h
- n      
2
3
2 1  rv��
�� 
pnam
3 n  hr
4
5
4 4  kr��
6
�� 
docf
6 o  nq���� 0 currentfile currentFile
5 o  hk���� 0 	newfolder 	newFolder
*    should only happen once		   
+ �
7
7 4   s h o u l d   o n l y   h a p p e n   o n c e 	 	
! 
8
9
8 = z�
:
;
: o  z}���� 0 currentfile currentFile
; l }�
<����
< b  }�
=
>
= o  }�����  0 oldprojectname oldProjectName
> m  ��
?
? �
@
@  _ P r e f i x . h��  ��  
9 
A��
A l ��
B
C
D
B r  ��
E
F
E b  ��
G
H
G o  ������  0 newprojectname newProjectName
H m  ��
I
I �
J
J  _ P r e f i x . h
F n      
K
L
K 1  ����
�� 
pnam
L n  ��
M
N
M 4  ����
O
�� 
docf
O o  ������ 0 currentfile currentFile
N o  ������ 0 	newfolder 	newFolder
C   should only happen once	   
D �
P
P 2   s h o u l d   o n l y   h a p p e n   o n c e 	��  �  �  
 
Q
R
Q =  ��
S
T
S o  ������ 0 currentfile currentFile
T b  ��
U
V
U o  ������  0 oldprojectname oldProjectName
V m  ��
W
W �
X
X  . n i b
R 
Y
Z
Y k  ��
[
[ 
\
]
\ r  ��
^
_
^ b  ��
`
a
` o  ������  0 newprojectname newProjectName
a m  ��
b
b �
c
c  . n i b
_ n      
d
e
d 1  ����
�� 
pnam
e n  ��
f
g
f 4  ����
h
�� 
docf
h o  ������ 0 currentfile currentFile
g n  ��
i
j
i 4  ����
k
�� 
cfol
k o  ������ 0 	nibfolder 	nibFolder
j o  ������ 0 	newfolder 	newFolder
] 
l
m
l l ����������  ��  ��  
m 
n��
n l ����
o
p��  
o       
p �
q
q     ��  
Z 
r
s
r D  ��
t
u
t o  ������ 0 currentfile currentFile
u m  ��
v
v �
w
w  . p l i s t
s 
x��
x k  �	�
y
y 
z
{
z r  ��
|
}
| m  ��
~
~ �

  . p l i s t
} o      ���� 0 
filesuffix 
fileSuffix
{ 
�
�
� n �	
�
�
� I  �	��
����� &0 replacetextinfile replaceTextInFile
� 
�
�
� o  ������ 0 currentfile currentFile
� 
�
�
� o  ������  0 oldprojectname oldProjectName
� 
�
�
� o  ������  0 newprojectname newProjectName
� 
�
�
� o  ������ 0 
old_prefix  
� 
���
� o  �	���� 0 
new_prefix  ��  ��  
�  f  ��
� 
�
�
� r  		
�
�
� I 		��
���
�� .sysoctonshor       TEXT
� l 		
�����
� n  		
�
�
� 4 		��
�
�� 
cobj
� m  		���� 
� o  		����  0 oldprojectname oldProjectName��  ��  ��  
� o      ���� 0 testchar testChar
� 
�
�
� Z  		|
�
�����
� F  		0
�
�
� @  		"
�
�
� o  		���� 0 testchar testChar
� m  		!���� A
� B  	%	,
�
�
� o  	%	(���� 0 testchar testChar
� m  	(	+���� Z
� l 	3	x
�
�
�
� k  	3	x
�
� 
�
�
� r  	3	:
�
�
� m  	3	6
�
� �
�
�  
� o      ���� 
0 locase  
� 
�
�
� Y  	;	d
���
�
���
� r  	M	_
�
�
� b  	M	[
�
�
� o  	M	P���� 
0 locase  
� l 	P	Z
�����
� n  	P	Z
�
�
� 4  	U	Z��
�
�� 
cobj
� o  	X	Y���� 0 n  
� o  	P	U����  0 oldprojectname oldProjectName��  ��  
� o      ���� 
0 locase  �� 0 n  
� m  	>	?���� 
� l 	?	H
�����
� I 	?	H��
���
�� .corecnte****       ****
� o  	?	D����  0 oldprojectname oldProjectName��  ��  ��  ��  
� 
���
� r  	e	x
�
�
� b  	e	t
�
�
� l 	e	p
�����
� I 	e	p��
���
�� .sysontocTEXT       shor
� l 	e	l
�����
� [  	e	l
�
�
� o  	e	h���� 0 testchar testChar
� m  	h	k����  ��  ��  ��  ��  ��  
� o  	p	s���� 
0 locase  
� o      ���� 
0 locase  ��  
�   is it uppercase ?   
� �
�
� $   i s   i t   u p p e r c a s e   ?��  ��  
� 
�
�
� l 	}	�
�
�
�
� n 	}	�
�
�
� I  	~	���
����� &0 simplereplacetext simpleReplaceText
� 
�
�
� o  	~	����� 0 currentfile currentFile
� 
�
�
� o  	�	����� 
0 locase  
� 
���
� o  	�	�����  0 newprojectname newProjectName��  ��  
�  f  	}	~
� 7 1 catch any lowercase instances of project name 		   
� �
�
� b   c a t c h   a n y   l o w e r c a s e   i n s t a n c e s   o f   p r o j e c t   n a m e   	 	
� 
�
�
� l 	�	���
�
���  
� ; 5 rename only .plist files containing the projectname    
� �
�
� j   r e n a m e   o n l y   . p l i s t   f i l e s   c o n t a i n i n g   t h e   p r o j e c t n a m e  
� 
���
� r  	�	�
�
�
� l 	�	�
�����
� I 	�	���
�
��� 0 searchreplace searchReplace
�  f  	�	�
� ��
�
�
�� 
into
� o  	�	����� 0 currentfile currentFile
� ��
�
�
�� 
at  
� o  	�	�����  0 oldprojectname oldProjectName
� ��
����� 0 replacestring replaceString
� o  	�	�����  0 newprojectname newProjectName��  ��  ��  
� n      
�
�
� 1  	�	���
�� 
pnam
� n  	�	�
�
�
� 4  	�	���
�
�� 
docf
� o  	�	����� 0 currentfile currentFile
� o  	�	����� 0 	newfolder 	newFolder��  ��  �/  	� 5 / handle special cases of files without prefixes   	� �
�
� ^   h a n d l e   s p e c i a l   c a s e s   o f   f i l e s   w i t h o u t   p r e f i x e s�	  � 0 n  � m  ������ � o  ������ 0 numfiles numFiles�  � 
�
�
� l 	�	���������  ��  ��  
� 
�
�
� l 	�	���
�
���  
� : 4 finally rename duplicate folder to new project name   
� �
�
� h   f i n a l l y   r e n a m e   d u p l i c a t e   f o l d e r   t o   n e w   p r o j e c t   n a m e
� 
�
�
� r  	�	�
�
�
� o  	�	�����  0 newprojectname newProjectName
� n      
�
�
� 1  	�	���
�� 
pnam
� o  	�	����� 0 	newfolder 	newFolder
� 
�
�
� l 	�	���������  ��  ��  
� 
�
�
� l 	�	���
�
���  
� I C Conclude the progress bar. This 'resets' the progress bar's state.   
� �
�
� �   C o n c l u d e   t h e   p r o g r e s s   b a r .   T h i s   ' r e s e t s '   t h e   p r o g r e s s   b a r ' s   s t a t e .
� 
�
�
� n  	�	�
� 
� I  	�	��������� 0 stopprogbar stopProgBar��  ��     f  	�	�
� �� l 	�	���������  ��  ��  ��  q m  �                                                                                  MACS  alis    0  JHRM                           BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  n 0 * end finder script for renaming everything   o � T   e n d   f i n d e r   s c r i p t   f o r   r e n a m i n g   e v e r y t h i n gl  l     ��������  ��  ��    l     ��	��   � z Go into Project .xcodeproj package and replace all prefixes and names to fix broken links within xcode paths and targets    	 �

 �   G o   i n t o   P r o j e c t   . x c o d e p r o j   p a c k a g e   a n d   r e p l a c e   a l l   p r e f i x e s   a n d   n a m e s   t o   f i x   b r o k e n   l i n k s   w i t h i n   x c o d e   p a t h s   a n d   t a r g e t s    l 	�	���~ r  	�	� c  	�	� b  	�	� b  	�	� b  	�	� b  	�	� o  	�	��}�} 0 myhome myHome o  	�	��|�|  0 newprojectname newProjectName m  	�	� �  / o  	�	��{�{  0 newprojectname newProjectName m  	�	� �  . x c o d e p r o j m  	�	��z
�z 
TEXT o      �y�y 0 mypath myPath�  �~    l 	�	� !"  r  	�	�#$# m  	�	�%% �&&  . p b x p r o j$ o      �x�x 0 
filesuffix 
fileSuffix!   set global variable   " �'' (   s e t   g l o b a l   v a r i a b l e ()( l     �w�v�u�w  �v  �u  ) *+* l 	�
,�t�s, I  	�
�r-�q�r &0 simplereplacetext simpleReplaceText- ./. m  	�
00 �11  p r o j e c t . p b x p r o j/ 232 o  

�p�p  0 oldprojectname oldProjectName3 4�o4 o  

	�n�n  0 newprojectname newProjectName�o  �q  �t  �s  + 565 l     �m�l�k�m  �l  �k  6 787 l     �j9:�j  9 _ Y --------more detailed search of project file structure to prevent incorrect replacements   : �;; �   - - - - - - - - m o r e   d e t a i l e d   s e a r c h   o f   p r o j e c t   f i l e   s t r u c t u r e   t o   p r e v e n t   i n c o r r e c t   r e p l a c e m e n t s8 <=< l 

>�i�h> r  

?@? c  

ABA b  

CDC m  

EE �FF  p a t h   =  D o  

�g�g 0 
old_prefix  B m  

�f
�f 
TEXT@ o      �e�e 0 pathoprefix  �i  �h  = GHG l 

-I�d�cI r  

-JKJ c  

)LML b  

%NON m  

!PP �QQ  p a t h   =  O o  
!
$�b�b 0 
new_prefix  M m  
%
(�a
�a 
TEXTK o      �`�` 0 pathnprefix  �d  �c  H RSR l 
.
<T�_�^T I  
.
<�]U�\�] &0 simplereplacetext simpleReplaceTextU VWV m  
/
2XX �YY  p r o j e c t . p b x p r o jW Z[Z o  
2
5�[�[ 0 pathoprefix  [ \�Z\ o  
5
8�Y�Y 0 pathnprefix  �Z  �\  �_  �^  S ]^] l     �X�W�V�X  �W  �V  ^ _`_ l 
=
La�U�Ta r  
=
Lbcb c  
=
Hded b  
=
Dfgf m  
=
@hh �ii  n a m e   =  g o  
@
C�S�S 0 
old_prefix  e m  
D
G�R
�R 
TEXTc o      �Q�Q 0 nameoprefix  �U  �T  ` jkj l 
M
\l�P�Ol r  
M
\mnm c  
M
Xopo b  
M
Tqrq m  
M
Pss �tt  n a m e   =  r o  
P
S�N�N 0 
new_prefix  p m  
T
W�M
�M 
TEXTn o      �L�L 0 namenprefix  �P  �O  k uvu l 
]
kw�K�Jw I  
]
k�Ix�H�I &0 simplereplacetext simpleReplaceTextx yzy m  
^
a{{ �||  p r o j e c t . p b x p r o jz }~} o  
a
d�G�G 0 nameoprefix  ~ �F o  
d
g�E�E 0 namenprefix  �F  �H  �K  �J  v ��� l     �D�C�B�D  �C  �B  � ��� l 
l
{��A�@� r  
l
{��� c  
l
w��� b  
l
s��� m  
l
o�� ���  H E A D E R   =  � o  
o
r�?�? 0 
old_prefix  � m  
s
v�>
�> 
TEXT� o      �=�= 0 nameoprefix  �A  �@  � ��� l 
|
���<�;� r  
|
���� c  
|
���� b  
|
���� m  
|
�� ���  H E A D E R   =  � o  

��:�: 0 
new_prefix  � m  
�
��9
�9 
TEXT� o      �8�8 0 namenprefix  �<  �;  � ��� l 
�
���7�6� I  
�
��5��4�5 &0 simplereplacetext simpleReplaceText� ��� m  
�
��� ���  p r o j e c t . p b x p r o j� ��� o  
�
��3�3 0 nameoprefix  � ��2� o  
�
��1�1 0 namenprefix  �2  �4  �7  �6  � ��� l     �0�/�.�0  �/  �.  � ��� l 
�
���-�,� r  
�
���� c  
�
���� b  
�
���� b  
�
���� b  
�
���� m  
�
��� ���  p a t h   =  � o  
�
��+�+ 0 	nibfolder 	nibFolder� m  
�
��� ���  \ /� o  
�
��*�* 0 
old_prefix  � m  
�
��)
�) 
TEXT� o      �(�( 0 nibpathoprefix  �-  �,  � ��� l 
�
���'�&� r  
�
���� c  
�
���� b  
�
���� b  
�
���� b  
�
���� m  
�
��� ���  p a t h   =  � o  
�
��%�% 0 	nibfolder 	nibFolder� m  
�
��� ���  \ /� o  
�
��$�$ 0 
new_prefix  � m  
�
��#
�# 
TEXT� o      �"�" 0 nibpathnprefix  �'  �&  � ��� l 
�
���!� � I  
�
����� &0 simplereplacetext simpleReplaceText� ��� m  
�
��� ���  p r o j e c t . p b x p r o j� ��� o  
�
��� 0 nibpathoprefix  � ��� o  
�
��� 0 nibpathnprefix  �  �  �!  �   � ��� l     ����  �  �  � ��� l 
�
����� r  
�
���� c  
�
���� b  
�
���� b  
�
���� b  
�
���� m  
�
��� ���  n a m e   =  � o  
�
��� 0 	nibfolder 	nibFolder� m  
�
��� ���  \ /� o  
�
��� 0 
old_prefix  � m  
�
��
� 
TEXT� o      �� 0 nibpathoprefix  �  �  � ��� l 
����� r  
���� c  
���� b  
�	��� b  
���� b  
���� m  
�
��� ���  n a m e   =  � o  
� �� 0 	nibfolder 	nibFolder� m  �� ���  \ /� o  �� 0 
new_prefix  � m  	�
� 
TEXT� o      �� 0 nibpathnprefix  �  �  � ��� l  ���
� I   �	���	 &0 simplereplacetext simpleReplaceText� ��� m  �� ���  p r o j e c t . p b x p r o j� ��� o  �� 0 nibpathoprefix  �  �  o  �� 0 nibpathnprefix  �  �  �  �
  �  l     ����  �  �    l     �� ���  �   ��    l     ����     clean new project    �		 $   c l e a n   n e w   p r o j e c t 

 l !6���� r  !6 c  !0 b  !, b  !( o  !$���� 0 myhome myHome o  $'����  0 newprojectname newProjectName m  (+ �  / m  ,/��
�� 
TEXT o      ���� 0 mypath myPath��  ��    l 7V r  7V l 7R���� I 7R������ 0 searchreplace searchReplace��   �� !
�� 
into  o  ;@���� 0 mypath myPath! ��"#
�� 
at  " l CF$����$ m  CF%% �&&   ��  ��  # ��'���� 0 replacestring replaceString' m  IL(( �))  \ %��  ��  ��   o      ���� 0 	shellpath 	ShellPath H B uses global variable to overcome POSIX issue with spaces in names    �** �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e s +,+ l Wt-����- r  Wt./. l Wp0����0 I Wp����1�� 0 searchreplace searchReplace��  1 ��23
�� 
into2 o  [^���� 0 	shellpath 	ShellPath3 ��45
�� 
at  4 m  ad66 �77  %5 ��8���� 0 replacestring replaceString8 m  gj99 �::   ��  ��  ��  / o      ���� 0 	shellpath 	ShellPath��  ��  , ;<; l u�=>?= r  u�@A@ b  u�BCB b  u|DED m  uxFF �GG  r m  E o  x{���� 0 	shellpath 	ShellPathC o  |����� &0 replacescriptname replaceScriptNameA o      ���� 0 cmd  > 5 / remove sed script file from new project folder   ? �HH ^   r e m o v e   s e d   s c r i p t   f i l e   f r o m   n e w   p r o j e c t   f o l d e r< IJI l ��K����K I ����L��
�� .sysoexecTEXT���     TEXTL o  ������ 0 cmd  ��  ��  ��  J MNM l ��O����O r  ��PQP b  ��RSR b  ��TUT m  ��VV �WW  c d  U o  ������ 0 	shellpath 	ShellPathS m  ��XX �YY < ;   x c o d e b u i l d   - a l l t a r g e t s   c l e a nQ o      ���� 0 cmd  ��  ��  N Z[Z l ��\����\ I ����]��
�� .sysoexecTEXT���     TEXT] o  ������ 0 cmd  ��  ��  ��  [ ^_^ l     ��������  ��  ��  _ `a` l     ��bc��  b   end of copyXproject   c �dd (   e n d   o f   c o p y X p r o j e c ta efe l ��g����g I ��������
�� .miscactvnull��� ��� null��  ��  ��  ��  f hih l ��j����j I ����kl
�� .sysodlogaskr        TEXTk b  ��mnm o  ������  0 newprojectname newProjectNamen m  ��oo �pp $   h a s   b e e n   c r e a t e d !l ��q��
�� 
dispq m  ����
�� stic   ��  ��  ��  i rsr l     ��������  ��  ��  s t��t l     ��������  ��  ��  ��       ��u  % . 7 @vwxyz{|}~�������  u ������������������������������������������ 0 	nibfolder 	nibFolder�� &0 replacescriptname replaceScriptName��  0 oldprojectname oldProjectName�� 0 mypath myPath�� 0 
filesuffix 
fileSuffix�� &0 replacetextinfile replaceTextInFile�� &0 simplereplacetext simpleReplaceText�� 0 searchreplace searchReplace�� 0 upcase upCase��  0 prepareprogbar prepareProgBar�� $0 incrementprogbar incrementProgBar�� 0 fadeinprogbar fadeinProgBar��  0 fadeoutprogbar fadeoutProgBar�� 0 showprogbar showProgBar�� 0 hideprogbar hideProgBar�� 0 
barberpole 
barberPole��  0 killbarberpole killBarberPole�� 0 startprogbar startProgBar�� 0 stopprogbar stopProgBar
�� .aevtoappnull  �   � ****v �� ����������� &0 replacetextinfile replaceTextInFile�� ����� �  ������������ 0 thefile theFile�� 0 oldtext1  �� 0 newtext1  �� 0 oldtext2  �� 0 newtext2  ��  � ������������������������ 0 thefile theFile�� 0 oldtext1  �� 0 newtext1  �� 0 oldtext2  �� 0 newtext2  �� 0 tempfile tempFile�� "0 scriptfilefound scriptFileFound�� 0 filename fileName�� 0 fileid fileID�� 0 	shellpath 	ShellPath�� 0 cmd  � 5 � �����������������
����������0��3��~@Cy{}��������}����������
�� 
cfol
�� 
file
�� .coredoexnull���     ****
�� 
psxf
�� 
perm
�� .rdwropenshor       file�� 

�� .sysontocTEXT       shor
�� 
refn
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****
�� 
into
�� 
at  �� 0 replacestring replaceString� �~ 0 searchreplace searchReplace
�} .sysoexecTEXT���     TEXT��]�E�O� *�b  /�b  /j E�UO� ab  b  %E�O*�/�el E�O�%�%�%�%�j %�%�%�%�j %�%�%a %�%a %�j %a %a �l O�j Y hO*a b  a a a a a  E�O*a �a a a a a  E�Oa �%�%a  %�%�%a !%a "%�%�%a #%a $%�%a %%�%a &%�%�%a '%�%�%a (%a )%�%�%E�O�j *Oa +�%�%a ,%�%�%a -%a .%�%�%a /%a 0%�%b  %a 1%�%�%a 2%�%�%a 3%a 4%�%�%E�O�j *w �|��{�z���y�| &0 simplereplacetext simpleReplaceText�{ �x��x �  �w�v�u�w 0 thefile theFile�v 0 oldtext  �u 0 newtext newText�z  � �t�s�r�q�p�o�t 0 thefile theFile�s 0 oldtext  �r 0 newtext newText�q 0 tempfile tempFile�p 0 	shellpath 	ShellPath�o 0 cmd  � ��n�m�l�k�j�iFHJLNPRTV�h
�n 
TEXT
�m 
into
�l 
at  �k 0 replacestring replaceString�j �i 0 searchreplace searchReplace
�h .sysoexecTEXT���     TEXT�y `�b  %�&E�O*�b  ����� E�O*������ E�O�%�%�%�%�%�%�%�%�%a %�%a %�%a %�%a %�%E�O�j x �ge�f�e���d�g 0 searchreplace searchReplace�f  �e �c�b�
�c 
into�b 0 
mainstring 
mainString� �a�`�
�a 
at  �` 0 searchstring searchString� �_�^�]�_ 0 replacestring replaceString�^ 0 replacestring replaceString�]  � �\�[�Z�Y�X�W�\ 0 
mainstring 
mainString�[ 0 searchstring searchString�Z 0 replacestring replaceString�Y 0 foundoffset foundOffset�X 0 stringstart stringStart�W 0 	stringend 	stringEnd� �V�U�T�S��R�Q
�V 
psof
�U 
psin�T 
�S .sysooffslong    ��� null
�R 
ctxt
�Q .corecnte****       ****�d T Oh��*��� E�O�k  �E�Y �[�\[Zk\Z�k2E�O�[�\[Z��j \Zi2E�O��%�%E�[OY��O�y �P��O�N���M�P 0 upcase upCase�O �L��L �  �K�K 0 astring aString�N  � �J�I�H�G�J 0 astring aString�I 
0 buffer  �H 0 i  �G 0 testchar testChar� 	��F�E�D�C�B�A�@�?
�F .corecnte****       ****
�E 
cobj
�D .sysoctonshor       TEXT�C a�B z
�A 
bool�@  
�? .sysontocTEXT       shor�M Q�E�O Hk�j kh ��/j E�O��	 ���& ���j %E�OPY ��j %E�OPOP[OY��O�z �>;�=�<���;�>  0 prepareprogbar prepareProgBar�= �:��: �  �9�8�9 0 somemaxcount someMaxCount�8 0 
windowname 
windowName�<  � �7�6�7 0 somemaxcount someMaxCount�6 0 
windowname 
windowName� ��5�4�3�2�1�0�/�.�-�,�+�*s�)�(�'�&�%�5   ��
�4 
cwin
�3 
bacC
�2 
hasS�1 �0 �/ �. e�-��, 
�+ 
cobj
�* 
levV
�) 
titl
�( 
proI
�' 
conT
�& 
minW
�% 
maxV�; b� ^���mv*�/�,FOe*�/�,FOjm������v��/*�/�,FO�*�/�,FOj*�/�k/a ,FOj*�/�k/a ,FO�*�/�k/a ,FU{ �$��#�"���!�$ $0 incrementprogbar incrementProgBar�# � ��  �  ���� 0 
itemnumber 
itemNumber� 0 somemaxcount someMaxCount� 0 
windowname 
windowName�"  � ���� 0 
itemnumber 
itemNumber� 0 somemaxcount someMaxCount� 0 
windowname 
windowName� 
����������� 0 filelist fileList
� 
cobj
� 
cwin
� 
titl
� 
proI
� 
conT�! '� #�%�%�%�%��/%*�/�,FO�*�/�k/�,FU| �������� 0 fadeinprogbar fadeinProgBar� ��� �  �� 0 
windowname 
windowName�  � ���� 0 
windowname 
windowName� 0 	fadevalue 	fadeValue� 0 i  � 
�
�	�������
�
 
cwin
�	 .appScentnull���    obj 
� 
alpV
� 
pvis� 	
� 
proI
� 
usTA
� .coVSstaAnull���    obj � P� L*�/j Oj*�/�,FOe*�/�,FO�E�O j�kh �*�/�,FO��E�[OY��O*�/�k/�el 	U} ��� �����  0 fadeoutprogbar fadeoutProgBar� ����� �  ���� 0 
windowname 
windowName�   � �������� 0 
windowname 
windowName�� 0 	fadevalue 	fadeValue�� 0 i  � 
I��������/����B��
�� 
cwin
�� 
proI
�� 
usTA
�� .coVSstoTnull���    obj �� 	
�� 
alpV
�� 
pvis�� >� :*�/�k/�el O�E�O k�kh �*�/�,FO��E�[OY��Of*�/�,FU~ ��T���������� 0 showprogbar showProgBar�� ����� �  ���� 0 
windowname 
windowName��  � ���� 0 
windowname 
windowName� m������������
�� 
cwin
�� .appScentnull���    obj 
�� 
pvis
�� 
proI
�� 
usTA
�� .coVSstaAnull���    obj �� %� !*�/j Oe*�/�,FO*�/�k/�el U ��x���������� 0 hideprogbar hideProgBar�� ����� �  ���� 0 
windowname 
windowName��  � ���� 0 
windowname 
windowName� �����������
�� 
cwin
�� 
proI
�� 
usTA
�� .coVSstoTnull���    obj 
�� 
pvis�� � *�/�k/�el Of*�/�,FU� ������������� 0 
barberpole 
barberPole�� ����� �  ���� 0 
windowname 
windowName��  � ���� 0 
windowname 
windowName� �������
�� 
cwin
�� 
proI
�� 
indR�� � e*�/�k/�,FU� �������������  0 killbarberpole killBarberPole�� ����� �  ���� 0 
windowname 
windowName��  � ���� 0 
windowname 
windowName� �������
�� 
cwin
�� 
proI
�� 
indR�� � f*�/�k/�,FU� ������������� 0 startprogbar startProgBar��  ��  �  � ���
�� .ascrnoop****      � ****�� � *j U� ������������� 0 stopprogbar stopProgBar��  ��  �  � ���
�� .aevtquitnull��� ��� null�� � *j U� �����������
�� .aevtoappnull  �   � ****� k    ���  O�� ��� ��� �� ;�� K�� d�� k�� �� �� *�� <�� G�� R�� _�� j�� u�� ��� ��� ��� ��� ��� ��� ��� ��� ��� 
�� �� +�� ;�� I�� M�� Z�� e�� h����  ��  ��  � ���� 0 n  � � W [ _ c g k o s w {  � � � � � ��������������������������������/��������RZ��k��o��u�����������������������������������������������$������������������Xlo��������������������%C����V��~�}��|�{�z�y�x�w�v�u�t�s�r�q<�p�o�n�m�lu~��������				$	6	>�k�j�i�h�g	i�f�e�d	�	�	�	�	�	�	�

'
0
?
I
W
b
v
~
��c%0E�bP�aXh�`s�_{������^���]������%(�\69F�[�ZVX�Yo�� ��  0 myreservedlist myReservedList�� 0 buttonpressed buttonPressed
�� 
prmp
�� .sysostflalis    ��� null
�� 
alis�� 0 	thefolder 	theFolder
�� .sysonfo4asfe        file
�� 
pnam
�� 
ascr
�� 
txdl�� 0 olddelimiter oldDelimiter
�� 
psxp
�� 
TEXT�� 0 myhome myHome
�� 
citm
�� .corecnte****       ****�� 0 totl  �� 
0 ending  ��  
�� 
dtxt
�� 
btns
�� 
dflt�� 
�� .sysodlogaskr        TEXT
�� 
rslt
�� 
list
�� 
cobj�� 0 button_pressed  �� 0 text_returned  ��  0 newprojectname newProjectName
�� 
into
�� 
at  �� 0 replacestring replaceString�� 0 searchreplace searchReplace�� 0 
old_prefix  �� 0 upcase upCase�� 0 kernel_beginning  
�� .sysobeepnull��� ��� long
�� 
disp
�� stic    �� 0 
new_prefix  �� 0�� 0 n  �� 

�� 
psof
�� .sysontocTEXT       shor
�� 
psin�� 
�� .sysooffslong    ��� null��  
�� stic   
�� .coreclon****      � ****�� 0 	newfolder 	newFolder� 0 startprogbar startProgBar
�~ 
ctxt�} 0 mybuildpath myBuildPath
�| 
lfiv
�{ .earslfdrutxt  @    file
�z .coredelonull���     obj 
�y 
file
�x 
cfol�w 0 filelist fileList�v 0 numfiles numFiles�u  0 prepareprogbar prepareProgBar�t 0 fadeinprogbar fadeinProgBar�s $0 incrementprogbar incrementProgBar�r 0 currentfile currentFile�q 0 filename_kernel  
�p .coredoexnull���     ****�o "0 myfileexisthere myFileExistHere�n �m &0 replacetextinfile replaceTextInFile
�l 
docf
�k .sysoctonshor       TEXT�j 0 testchar testChar�i A�h Z
�g 
bool�f 
0 locase  �e  �d &0 simplereplacetext simpleReplaceText�c 0 stopprogbar stopProgBar�b 0 pathoprefix  �a 0 pathnprefix  �` 0 nameoprefix  �_ 0 namenprefix  �^ 0 nibpathoprefix  �] 0 nibpathnprefix  �\ 0 	shellpath 	ShellPath�[ 0 cmd  
�Z .sysoexecTEXT���     TEXT
�Y .miscactvnull��� ��� null�������������������a a vE` Oa E` O�h_ a  *a a l a &E` O_ j a ,Ec  O p_ a ,E` O_ a  ,a !&E` "Oa #_ a ,FO_ "a $-j %E` &O_ &lE` 'O_ "[a $\[Zk\Z_ '2a !&a (%E` "O_ _ a ,FW X ) *_ _ a ,FOa +a ,a -a .a /kva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` 8O*a 9_ 8a :a ;a <a =a 1 >E` 8Oa ?b  %a @%a ,a Aa .a Bkva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` CO*a 9_ Ca :a Da <a Ea 1 >E` CO*_ Ck+ FE` CO_ Cj %kE` GO_ _ C *j HOa Ia Ja Kl 2OhY hOhZa L_ 8%a M%a ,a Na .a Okva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 7a !&E` PO �a QE` RO =a Skh*a T_ Rj Ua V_ Pa W Xj )ja YY hO_ RkE` R[OY��O*a 9_ Pa :a Za <a [a 1 >E` PO*_ Pk+ FE` PO_ _ P *j HOa \a Ja Kl 2Y W X ] *a ^a Ja Kl 2[OY� Oa _b  %a `%_ 8%a a%_ C%a b%_ P%a .a ca da emva 0ka Ja fa 1 2O_ 3a 4&E[a 5k/EQ` ZO_ a g l_ 8a h  a iE` Oa ja Ja Kl 2Y G_ Ca k  a lE` Oa ma Ja Kl 2Y %_ Pa n  a oE` Oa pa Ja Kl 2Y hY hOP[OY�bO_ a q  hY hOa r _ j sE` tUO_ "b  %a u%a !&Ec  O)j+ vOa r�_ ta w&E` xO_ xa y%a &E` xO_ xa zfl {jv _ xa 5-j |Y hO_ ta }-a ,E_ ta ~-a }-a ,E%E` O_ 3j %O_ 3E` �O)_ �kl+ �O)kk+ �O-k_ �kh  )�_ �km+ �O_ a 5�/EE` �O_ �_ C�_ �b   �a �E` �O &_ G_ �j %kh  _ �_ �a 5�/%E` �[OY��Oa � _ ta }_ �/j �E` �UO_ � 4)_ �b  _ 8_ C_ Pa �+ �O_ P_ �%_ ta �_ �/a ,FY !_ P_ �%_ ta ~b   /a �_ �/a ,FY$_ �a � _ 8a �%_ ta �_ �/a ,FY_ �a � _ 8a �%_ ta �_ �/a ,FY�_ �a � H)_ �b  _ 8_ C_ Pa �+ �O_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY hY�_ �a � q)_ �b  _ 8_ C_ Pa �+ �O_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY ,_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY hY_ �b  a �%  &_ 8a �%_ ta ~b   /a �_ �/a ,FOPY �_ �a � �a �Ec  O)_ �b  _ 8_ C_ Pa �+ �Ob  a 5k/j �E` �O_ �a �	 _ �a �a �& Ja �E` �O (lb  j %kh  _ �b  a 5�/%E` �[OY��O_ �a �j U_ �%E` �Y hO)_ �_ �_ 8m+ �O)a 9_ �a :b  a <_ 8a 1 >_ ta �_ �/a ,FY hOPY$_ �a � _ 8a �%_ ta �_ �/a ,FY_ �a � _ 8a �%_ ta �_ �/a ,FY�_ �a � H)_ �b  _ 8_ C_ Pa �+ �O_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY hY�_ �a � q)_ �b  _ 8_ C_ Pa �+ �O_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY ,_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY hY_ �b  a �%  &_ 8a �%_ ta ~b   /a �_ �/a ,FOPY �_ �a � �a �Ec  O)_ �b  _ 8_ C_ Pa �+ �Ob  a 5k/j �E` �O_ �a �	 _ �a �a �& Ja �E` �O (lb  j %kh  _ �b  a 5�/%E` �[OY��O_ �a �j U_ �%E` �Y hO)_ �_ �_ 8m+ �O)a 9_ �a :b  a <_ 8a 1 >_ ta �_ �/a ,FY h[OY��O_ 8_ ta ,FO)j+ �OPUO_ "_ 8%a �%_ 8%a �%a !&Ec  Oa �Ec  O*a �b  _ 8m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �b   %a �%_ C%a !&E` �Oa �b   %a �%_ P%a !&E` �O*a �_ �_ �m+ �Oa �b   %a �%_ C%a !&E` �Oa �b   %a �%_ P%a !&E` �O*a �_ �_ �m+ �O_ "_ 8%a �%a !&Ec  O*a 9b  a :a �a <a �a 1 >E` �O*a 9_ �a :a �a <a �a 1 >E` �Oa �_ �%b  %E` �O_ �j �Oa �_ �%a �%E` �O_ �j �O*j �O_ 8a �%a Ja fl 2ascr  ��ޭ
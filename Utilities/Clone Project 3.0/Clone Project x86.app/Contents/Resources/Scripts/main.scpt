FasdUAS 1.101.10   ��   ��    k             l     ��  ��    B < clone Project  v. 0.71  app script   (Xcode 2.1 compatible)     � 	 	 x   c l o n e   P r o j e c t     v .   0 . 7 1     a p p   s c r i p t       ( X c o d e   2 . 1   c o m p a t i b l e )   
  
 l     ��  ��    * $ Craig G. Hocker - HHMI - 12/14/2005     �   H   C r a i g   G .   H o c k e r   -   H H M I   -   1 2 / 1 4 / 2 0 0 5      l     ��������  ��  ��        l     ��  ��      Global variables     �   "   G l o b a l   v a r i a b l e s      l          j     �� �� 0 	nibfolder 	nibFolder  m        �    E n g l i s h . l p r o j  B < location of Interface Builder files in Xcode project folder     �   x   l o c a t i o n   o f   I n t e r f a c e   B u i l d e r   f i l e s   i n   X c o d e   p r o j e c t   f o l d e r       l      ! " # ! j    �� $�� &0 replacescriptname replaceScriptName $ m     % % � & &  m y s c r i p t . t x t " = 7 file created containing sed script for unix bash shell    # � ' ' n   f i l e   c r e a t e d   c o n t a i n i n g   s e d   s c r i p t   f o r   u n i x   b a s h   s h e l l    ( ) ( l      * + , * j    �� -��  0 oldprojectname oldProjectName - m     . . � / /  o l d p r o j e c t + 6 0 project folder name of project to be duplicated    , � 0 0 `   p r o j e c t   f o l d e r   n a m e   o f   p r o j e c t   t o   b e   d u p l i c a t e d )  1 2 1 l      3 4 5 3 j   	 �� 6�� 0 mypath myPath 6 m   	 
 7 7 � 8 8  / U s e r s / 4 1 + POSIX path to location of files or folders    5 � 9 9 V   P O S I X   p a t h   t o   l o c a t i o n   o f   f i l e s   o r   f o l d e r s 2  : ; : l      < = > < j    �� ?�� 0 
filesuffix 
fileSuffix ? m     @ @ � A A  . p l i s t = ( " file suffix changed with context     > � B B D   f i l e   s u f f i x   c h a n g e d   w i t h   c o n t e x t   ;  C D C l      E F G E p     H H ������ 0 filelist fileList��   F 9 3  all Files found in project folder and sub folders    G � I I f     a l l   F i l e s   f o u n d   i n   p r o j e c t   f o l d e r   a n d   s u b   f o l d e r s D  J K J l     �� L M��   L   list of illegal prefixes    M � N N 2   l i s t   o f   i l l e g a l   p r e f i x e s K  O P O l     Q���� Q r      R S R J      T T  U V U m      W W � X X  N S V  Y Z Y m     [ [ � \ \  N S S Z  ] ^ ] m     _ _ � ` `  V B L ^  a b a m     c c � d d  V B L C b  e f e m     g g � h h  L L f  i j i m     k k � l l  C C j  m n m m     o o � p p  G G n  q r q m     s s � t t  P B r  u v u m    	 w w � x x  P B X v  y z y m   	 
 { { � | |  P B X F z  } ~ } m   
    � � �  P B X V ~  � � � m     � � � � �  P B X B �  � � � m     � � � � �  I T �  � � � m     � � � � �  I T C �  � � � m     � � � � �  B O �  � � � m     � � � � �  B O O �  ��� � m     � � � � �  B O O L��   S o      ����  0 myreservedlist myReservedList��  ��   P  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �  //////////  subroutines    � � � � . / / / / / / / / / /     s u b r o u t i n e s �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � J D subroutine to replace old file names and prefixes with the new ones    � � � � �   s u b r o u t i n e   t o   r e p l a c e   o l d   f i l e   n a m e s   a n d   p r e f i x e s   w i t h   t h e   n e w   o n e s �  � � � i    � � � I      �� ����� &0 replacetextinfile replaceTextInFile �  � � � o      ���� 0 thefile theFile �  � � � o      ���� 0 oldtext1   �  � � � o      ���� 0 newtext1   �  � � � o      ���� 0 oldtext2   �  ��� � o      ���� 0 newtext2  ��  ��   � k    \ � �  � � � r      � � � m      � � � � �  m y t e m p . h � o      ���� 0 tempfile tempFile �  � � � O    � � � r     � � � l    ����� � I   �� ���
�� .coredoexbool       obj  � l    ����� � n     � � � 4    �� �
�� 
file � o    ���� &0 replacescriptname replaceScriptName � 4    �� �
�� 
cfol � o   
 ���� 0 mypath myPath��  ��  ��  ��  ��   � o      ���� "0 scriptfilefound scriptFileFound � m     � ��                                                                                  sevs  alis    z  JHRM                       ϓr�H+     /System Events.app                                               �M�P�~        ����  	                CoreServices    ϓ�;      �Q&�       /   ,   +  5JHRM:System: Library: CoreServices: System Events.app   $  S y s t e m   E v e n t s . a p p  
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
windowName��  ��  ; O     a@A@ k    `BB CDC r    EFE J    	GG HIH m    ����   ��I JKJ m    ����   ��K L��L m    ����   ����  F n      MNM m    ��
�� 
bacCN 4   	 ��O
�� 
cwinO o    ���� 0 
windowname 
windowNameD PQP r    RSR m    ��
�� boovtrueS n      TUT m    ��
�� 
hasSU 4    ��V
�� 
cwinV o    ���� 0 
windowname 
windowNameQ WXW r    -YZY n    &[\[ 4   # &��]
�� 
cobj] m   $ %���� \ J    #^^ _`_ m    ����  ` aba m    ���� b cdc m    ���� d efe m    ���� f ghg m    ���� h iji m     ���� ej k��k m     !�������  Z n      lml m   * ,��
�� 
levVm 4   & *��n
�� 
cwinn o   ( )���� 0 
windowname 
windowNameX opo r   . 6qrq m   . /ss �tt  r n      uvu m   3 5��
�� 
titlv 4   / 3��w
�� 
cwinw o   1 2���� 0 
windowname 
windowNamep xyx r   7 Dz{z m   7 8����  { n      |}| m   ? C��
�� 
conT} n   8 ?~~ 4   < ?���
�� 
proI� m   = >����  4   8 <���
�� 
cwin� o   : ;���� 0 
windowname 
windowNamey ��� r   E R��� m   E F����  � n      ��� m   M Q��
�� 
minW� n   F M��� 4   J M���
�� 
proI� m   K L���� � 4   F J���
�� 
cwin� o   H I���� 0 
windowname 
windowName� ���� r   S `��� o   S T�� 0 somemaxcount someMaxCount� n      ��� m   [ _�~
�~ 
maxV� n   T [��� 4   X [�}�
�} 
proI� m   Y Z�|�| � 4   T X�{�
�{ 
cwin� o   V W�z�z 0 
windowname 
windowName��  A m     ���                                                                                      @ alis    �  JHRM                       ϓr�H+   $ �ProgBar.app                                                     $	̵��        ����  	                Clone Project 3.0     ϓ�;      ̵��     $ � $ � #�} #�z  AJHRM:Documents: Lablib: Utilities: Clone Project 3.0: ProgBar.app     P r o g B a r . a p p  
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
itemNumber� o    �i�i 0 filelist fileList�m  �l  � n      ��� m    �h
�h 
titl� 4    �g�
�g 
cwin� o    �f�f 0 
windowname 
windowName� ��e� r    %��� o    �d�d 0 
itemnumber 
itemNumber� n      ��� m   " $�c
�c 
conT� n    "��� 4    "�b�
�b 
proI� m     !�a�a � 4    �`�
�` 
cwin� o    �_�_ 0 
windowname 
windowName�e  � m     ���                                                                                      @ alis    �  JHRM                       ϓr�H+   $ �ProgBar.app                                                     $	̵��        ����  	                Clone Project 3.0     ϓ�;      ̵��     $ � $ � #�} #�z  AJHRM:Documents: Lablib: Utilities: Clone Project 3.0: ProgBar.app     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  � ��� l     �^�]�\�^  �]  �\  � ��� l     �[���[  � %  Fade in a progress bar window.   � ��� >   F a d e   i n   a   p r o g r e s s   b a r   w i n d o w .� ��� i   ' *��� I      �Z��Y�Z 0 fadeinprogbar fadeinProgBar� ��X� o      �W�W 0 
windowname 
windowName�X  �Y  � O     O��� k    N�� ��� I   �V��U
�V .appScent****      � ****� 4    �T�
�T 
cwin� o    �S�S 0 
windowname 
windowName�U  � ��� r    ��� m    �R�R  � n      ��� m    �Q
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
windowName� ��� r    "��� m     �� ?�������� o      �J�J 0 	fadevalue 	fadeValue� ��� Y   # @��I���H� k   - ;�� ��� r   - 5��� o   - .�G�G 0 	fadevalue 	fadeValue� n         m   2 4�F
�F 
alpV 4   . 2�E
�E 
cwin o   0 1�D�D 0 
windowname 
windowName� �C r   6 ; [   6 9 o   6 7�B�B 0 	fadevalue 	fadeValue m   7 8 ?������� o      �A�A 0 	fadevalue 	fadeValue�C  �I 0 i  � m   & '�@�@  � m   ' (�?�? 	�H  � 	�>	 I  A N�=

�= .coVSstaA****      � ****
 n   A H 4   E H�<
�< 
proI m   F G�;�;  4   A E�:
�: 
cwin o   C D�9�9 0 
windowname 
windowName �8�7
�8 
usTA m   I J�6
�6 boovtrue�7  �>  � m     �                                                                                      @ alis    �  JHRM                       ϓr�H+   $ �ProgBar.app                                                     $	̵��        ����  	                Clone Project 3.0     ϓ�;      ̵��     $ � $ � #�} #�z  AJHRM:Documents: Lablib: Utilities: Clone Project 3.0: ProgBar.app     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  �  l     �5�4�3�5  �4  �3    l     �2�2   &   Fade out a progress bar window.    � @   F a d e   o u t   a   p r o g r e s s   b a r   w i n d o w .  i   + . I      �1�0�1  0 fadeoutprogbar fadeoutProgBar �/ o      �.�. 0 
windowname 
windowName�/  �0   O     =  k    <!! "#" I   �-$%
�- .coVSstoT****      � ****$ n    &'& 4    �,(
�, 
proI( m   	 
�+�+ ' 4    �*)
�* 
cwin) o    �)�) 0 
windowname 
windowName% �(*�'
�( 
usTA* m    �&
�& boovtrue�'  # +,+ r    -.- m    // ?�������. o      �%�% 0 	fadevalue 	fadeValue, 010 Y    32�$34�#2 k     .55 676 r     (898 o     !�"�" 0 	fadevalue 	fadeValue9 n      :;: m   % '�!
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
windowName�    m     II�                                                                                      @ alis    �  JHRM                       ϓr�H+   $ �ProgBar.app                                                     $	̵��        ����  	                Clone Project 3.0     ϓ�;      ̵��     $ � $ � #�} #�z  AJHRM:Documents: Lablib: Utilities: Clone Project 3.0: ProgBar.app     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��   JKJ l     ����  �  �  K LML l     �NO�  N    Show progress bar window.   O �PP 4   S h o w   p r o g r e s s   b a r   w i n d o w .M QRQ i   / 2STS I      �U�� 0 showprogbar showProgBarU V�V o      �� 0 
windowname 
windowName�  �  T O     $WXW k    #YY Z[Z I   �\�
� .appScent****      � ****\ 4    �
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
� .coVSstaA****      � ****f n    hih 4    �j
� 
proIj m    �� i 4    � k
�  
cwink o    ���� 0 
windowname 
windowNameg ��l��
�� 
usTAl m    ��
�� boovtrue��  �  X m     mm�                                                                                      @ alis    �  JHRM                       ϓr�H+   $ �ProgBar.app                                                     $	̵��        ����  	                Clone Project 3.0     ϓ�;      ̵��     $ � $ � #�} #�z  AJHRM:Documents: Lablib: Utilities: Clone Project 3.0: ProgBar.app     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  R non l     ��������  ��  ��  o pqp l     ��rs��  r    Hide progress bar window.   s �tt 4   H i d e   p r o g r e s s   b a r   w i n d o w .q uvu i   3 6wxw I      ��y���� 0 hideprogbar hideProgBary z��z o      ���� 0 
windowname 
windowName��  ��  x O     {|{ k    }} ~~ I   ����
�� .coVSstoT****      � ****� n    ��� 4    ���
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
windowName��  | m     ���                                                                                      @ alis    �  JHRM                       ϓr�H+   $ �ProgBar.app                                                     $	̵��        ����  	                Clone Project 3.0     ϓ�;      ̵��     $ � $ � #�} #�z  AJHRM:Documents: Lablib: Utilities: Clone Project 3.0: ProgBar.app     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  v ��� l     ��������  ��  ��  � ��� l     ������  � 7 1 Enable 'barber pole' behavior of a progress bar.   � ��� b   E n a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .� ��� i   7 :��� I      ������� 0 
barberpole 
barberPole� ���� o      ���� 0 
windowname 
windowName��  ��  � O     ��� r    ��� m    ��
�� boovtrue� n      ��� m    ��
�� 
indR� n    ��� 4   	 ���
�� 
proI� m   
 ���� � 4    	���
�� 
cwin� o    ���� 0 
windowname 
windowName� m     ���                                                                                      @ alis    �  JHRM                       ϓr�H+   $ �ProgBar.app                                                     $	̵��        ����  	                Clone Project 3.0     ϓ�;      ̵��     $ � $ � #�} #�z  AJHRM:Documents: Lablib: Utilities: Clone Project 3.0: ProgBar.app     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  � ��� l     ��������  ��  ��  � ��� l     ������  � 8 2 Disable 'barber pole' behavior of a progress bar.   � ��� d   D i s a b l e   ' b a r b e r   p o l e '   b e h a v i o r   o f   a   p r o g r e s s   b a r .� ��� i   ; >��� I      �������  0 killbarberpole killBarberPole� ���� o      ���� 0 
windowname 
windowName��  ��  � O     ��� r    ��� m    ��
�� boovfals� n      ��� m    ��
�� 
indR� n    ��� 4   	 ���
�� 
proI� m   
 ���� � 4    	���
�� 
cwin� o    ���� 0 
windowname 
windowName� m     ���                                                                                      @ alis    �  JHRM                       ϓr�H+   $ �ProgBar.app                                                     $	̵��        ����  	                Clone Project 3.0     ϓ�;      ̵��     $ � $ � #�} #�z  AJHRM:Documents: Lablib: Utilities: Clone Project 3.0: ProgBar.app     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  � ��� l     ��������  ��  ��  � ��� l     ������  �   Launch ProgBar.   � ���     L a u n c h   P r o g B a r .� ��� i   ? B��� I      �������� 0 startprogbar startProgBar��  ��  � O     
��� I   	������
�� .ascrnoop****      � ****��  ��  � m     ���                                                                                      @ alis    �  JHRM                       ϓr�H+   $ �ProgBar.app                                                     $	̵��        ����  	                Clone Project 3.0     ϓ�;      ̵��     $ � $ � #�} #�z  AJHRM:Documents: Lablib: Utilities: Clone Project 3.0: ProgBar.app     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  � ��� l     ��������  ��  ��  � ��� l     ������  �   Quit ProgBar.   � ���    Q u i t   P r o g B a r .� ��� i   C F��� I      �������� 0 stopprogbar stopProgBar��  ��  � O     
��� I   	������
�� .aevtquitnull��� ��� null��  ��  � m     ���                                                                                      @ alis    �  JHRM                       ϓr�H+   $ �ProgBar.app                                                     $	̵��        ����  	                Clone Project 3.0     ϓ�;      ̵��     $ � $ � #�} #�z  AJHRM:Documents: Lablib: Utilities: Clone Project 3.0: ProgBar.app     P r o g B a r . a p p  
  J H R M  8Documents/Lablib/Utilities/Clone Project 3.0/ProgBar.app  / ��  � ��� l     ��������  ��  ��  � ��� l     ������  �  ////////////  User input   � ��� 0 / / / / / / / / / / / /     U s e r   i n p u t� ��� l     ��������  ��  ��  � ��� l   #���� r    #��� m    �� ���  R E S U B M I T� o      ���� 0 buttonpressed buttonPressed�   at least try one time   � ��� ,   a t   l e a s t   t r y   o n e   t i m e� ��� l  $������� V   $���� k   0��� ��� l  0 0��������  ��  ��  � ��� l  0 0������  � + %  User chooses project folder to copy   � ��� J     U s e r   c h o o s e s   p r o j e c t   f o l d e r   t o   c o p y� ��� r   0 C��� c   0 ?��� l  0 ; ����  I  0 ;����
�� .sysostflalis    ��� null��   ����
�� 
prmp m   4 7 � h T o   d u p l i c a t e :   c h o o s e   P l u g i n   p r o j e c t   t o   u s e   a s   s o u r c e��  ��  ��  � m   ; >��
�� 
alis� o      ���� 0 	thefolder 	theFolder�  r   D U n   D O	
	 1   K O��
�� 
pnam
 l  D K���� I  D K����
�� .sysonfo4asfe        file o   D G���� 0 	thefolder 	theFolder��  ��  ��   o      ����  0 oldprojectname oldProjectName  l  V V��������  ��  ��    l  V V����   s m this extracts the path to folder in which the duplicated project folder resides and gives it the name myHome    � �   t h i s   e x t r a c t s   t h e   p a t h   t o   f o l d e r   i n   w h i c h   t h e   d u p l i c a t e d   p r o j e c t   f o l d e r   r e s i d e s   a n d   g i v e s   i t   t h e   n a m e   m y H o m e  l  V V����   1 + POSIX format because used by shell scripts    � V   P O S I X   f o r m a t   b e c a u s e   u s e d   b y   s h e l l   s c r i p t s  Q   V � k   Y �   r   Y d!"! n  Y `#$# 1   \ `��
�� 
txdl$ 1   Y \��
�� 
ascr" o      ���� 0 olddelimiter oldDelimiter  %&% r   e t'(' c   e p)*) n   e l+,+ 1   h l��
�� 
psxp, o   e h���� 0 	thefolder 	theFolder* m   l o��
�� 
TEXT( o      ���� 0 myhome myHome& -.- r   u �/0/ m   u x11 �22  /0 n     343 1   { ��
�� 
txdl4 1   x {��
�� 
ascr. 565 r   � �787 I  � ���9��
�� .corecnte****       ****9 l  � �:����: n   � �;<; 2   � ���
�� 
citm< o   � ����� 0 myhome myHome��  ��  ��  8 o      ���� 0 totl  6 =>= l  � �?@A? r   � �BCB \   � �DED o   � ����� 0 totl  E m   � ����� C o      ���� 
0 ending  @ + % remove current folder name from path   A �FF J   r e m o v e   c u r r e n t   f o l d e r   n a m e   f r o m   p a t h> GHG r   � �IJI b   � �KLK l  � �M����M c   � �NON n   � �PQP 7  � ��RS
� 
citmR m   � ��~�~ S o   � ��}�} 
0 ending  Q o   � ��|�| 0 myhome myHomeO m   � ��{
�{ 
TEXT��  ��  L m   � �TT �UU  /J o      �z�z 0 myhome myHomeH V�yV r   � �WXW o   � ��x�x 0 olddelimiter oldDelimiterX n     YZY 1   � ��w
�w 
txdlZ 1   � ��v
�v 
ascr�y   R      �u[�t
�u .ascrerr ****      � ****[ m      \\ �]] ~ e r r o r   o c c u r r e d   a t t e m p t i n g   t o   e x t r a c t   p a t h   t o   n e w   p r o j e c t   f o l d e r�t   r   � �^_^ o   � ��s�s 0 olddelimiter oldDelimiter_ n     `a` 1   � ��r
�r 
txdla 1   � ��q
�q 
ascr bcb l  � ��p�o�n�p  �o  �n  c ded l  � ��mfg�m  f ? 9 User chooses the name they wish to give the project copy   g �hh r   U s e r   c h o o s e s   t h e   n a m e   t h e y   w i s h   t o   g i v e   t h e   p r o j e c t   c o p ye iji I  � ��lkl
�l .sysodlogaskr        TEXTk m   � �mm �nn & N a m e   o f   n e w   p l u g i n ?l �kop
�k 
dtxto m   � �qq �rr  n e w P l u g i np �jst
�j 
btnss J   � �uu v�iv m   � �ww �xx    O K�i  t �hy�g
�h 
dflty m   � ��f�f �g  j z{z s   �|}| c   � �~~ l  � ���e�d� 1   � ��c
�c 
rslt�e  �d   m   � ��b
�b 
list} J      �� ��� o      �a�a 0 text_returned  � ��`� o      �_�_ 0 button_pressed  �`  { ��� r   ��� c  ��� o  �^�^ 0 text_returned  � m  �]
�] 
TEXT� o      �\�\  0 newprojectname newProjectName� ��� l !>���� r  !>��� l !:��[�Z� I !:�Y�X��Y 0 searchreplace searchReplace�X  � �W��
�W 
into� o  %(�V�V  0 newprojectname newProjectName� �U��
�U 
at  � m  +.�� ���   � �T��S�T 0 replacestring replaceString� m  14�� ���  �S  �[  �Z  � o      �R�R  0 newprojectname newProjectName�   remove all spaces   � ��� $   r e m o v e   a l l   s p a c e s� ��� l ??�Q�P�O�Q  �P  �O  � ��� l ??�N�M�L�N  �M  �L  � ��� l ??�K���K  � ? 9 User provides the current prefix of the original project   � ��� r   U s e r   p r o v i d e s   t h e   c u r r e n t   p r e f i x   o f   t h e   o r i g i n a l   p r o j e c t� ��� I ?d�J��
�J .sysodlogaskr        TEXT� l ?L��I�H� b  ?L��� b  ?H��� m  ?B�� ��� > W h a t   i s   t h e   c u r r e n t   p r e f i x   f o r  � o  BG�G�G  0 oldprojectname oldProjectName� m  HK�� ���    ?�I  �H  � �F��
�F 
dtxt� m  OR�� ���  F T� �E��
�E 
btns� J  UZ�� ��D� m  UX�� ���  O K�D  � �C��B
�C 
dflt� m  ]^�A�A �B  � ��� s  e���� c  el��� l eh��@�?� 1  eh�>
�> 
rslt�@  �?  � m  hk�=
�= 
list� J      �� ��� o      �<�< 0 text_returned  � ��;� o      �:�: 0 button_pressed  �;  � ��� r  ����� c  ����� o  ���9�9 0 text_returned  � m  ���8
�8 
TEXT� o      �7�7 0 
old_prefix  � ��� l ������ r  ����� l ����6�5� I ���4�3��4 0 searchreplace searchReplace�3  � �2��
�2 
into� o  ���1�1 0 
old_prefix  � �0��
�0 
at  � m  ���� ���   � �/��.�/ 0 replacestring replaceString� m  ���� ���  �.  �6  �5  � o      �-�- 0 
old_prefix  �   remove all spaces   � ��� $   r e m o v e   a l l   s p a c e s� ��� r  ����� I  ���,��+�, 0 upcase upCase� ��*� o  ���)�) 0 
old_prefix  �*  �+  � o      �(�( 0 
old_prefix  � ��� r  ����� [  ����� l ����'�&� I ���%��$
�% .corecnte****       ****� o  ���#�# 0 
old_prefix  �$  �'  �&  � m  ���"�" � o      �!�! 0 kernel_beginning  � ��� Z  ����� �� E  ����� o  ����  0 myreservedlist myReservedList� o  ���� 0 
old_prefix  � k  ���� ��� I �����
� .sysobeepnull��� ��� long�  �  � ��� I �����
� .sysodlogaskr        TEXT� m  ���� ��� W A R N I N G   - -   Y o u r   o r i g i n a l   p r e f i x   i s   o n   t h e   r e s e r v e d   l i s t .   U s a g e   o f   t h i s   p r e f i x   i s   n o t   a l l o w e d .   T h e   p r o j e c t   i s   n o t   c l o n a b l e .   E x i t   n o w .� � �
� 
disp  m  ���
� stic    �  � � l �� L  ����     abort program    �    a b o r t   p r o g r a m�  �   �  �  l ������  �  �   	 l ���
�  
 4 . User chooses new prefix to replace old prefix    � \   U s e r   c h o o s e s   n e w   p r e f i x   t o   r e p l a c e   o l d   p r e f i x	  T  �� k  ��  I ��
� .sysodlogaskr        TEXT l � �� b  �  b  �� m  �� � 6 W h a t   i s   t h e   n e w   p r e f i x   f o r   o  ����  0 newprojectname newProjectName m  �� �    ?  �  �   �
� 
dtxt m     �!!   �
"#
�
 
btns" J  	$$ %�	% m  	&& �''  O K�	  # �(�
� 
dflt( m  �� �   )*) s  9+,+ c   -.- l /��/ 1  �
� 
rslt�  �  . m  �
� 
list, J      00 121 o      �� 0 text_returned  2 3� 3 o      ���� 0 button_pressed  �   * 454 r  :E676 c  :A898 o  :=���� 0 text_returned  9 m  =@��
�� 
TEXT7 o      ���� 0 
new_prefix  5 :��: Q  F�;<=; k  I�>> ?@? l IPABCA r  IPDED m  IL���� 0E o      ���� 0 n  B   zero   C �FF 
   z e r o@ GHG U  Q�IJI k  Z�KK LML Z  Z�NO����N ?  ZsPQP l ZqR����R I Zq����S
�� .sysooffslong    ��� null��  S ��TU
�� 
psofT l ^eV����V I ^e��W��
�� .sysontocTEXT       shorW o  ^a���� 0 n  ��  ��  ��  U ��X��
�� 
psinX o  hk���� 0 
new_prefix  ��  ��  ��  Q m  qr����  O R  v|��Y��
�� .ascrerr ****      � ****Y m  x{ZZ �[[ L N u m b e r s   a r e   n o t   a l l o w e d   f o r   t h e   p r e f i x��  ��  ��  M \��\ r  ��]^] [  ��_`_ o  ������ 0 n  ` m  ������ ^ o      ���� 0 n  ��  J m  TW���� 
H aba l ��cdec r  ��fgf l ��h����h I ������i�� 0 searchreplace searchReplace��  i ��jk
�� 
intoj o  ������ 0 
new_prefix  k ��lm
�� 
at  l m  ��nn �oo   m ��p���� 0 replacestring replaceStringp m  ��qq �rr  ��  ��  ��  g o      ���� 0 
new_prefix  d   remove all spaces   e �ss $   r e m o v e   a l l   s p a c e sb tut r  ��vwv I  ����x���� 0 upcase upCasex y��y o  ������ 0 
new_prefix  ��  ��  w o      ���� 0 
new_prefix  u z��z Z  ��{|��}{ E  ��~~ o  ������  0 myreservedlist myReservedList o  ������ 0 
new_prefix  | k  ���� ��� I ��������
�� .sysobeepnull��� ��� long��  ��  � ���� I ������
�� .sysodlogaskr        TEXT� m  ���� ���  W A R N I N G !   - -   Y o u r   n e w   p r e f i x   i s   o n   t h e   r e s e r v e d   l i s t .   U s a g e   o f   t h i s   p r e f i x   i s   n o t   a l l o w e d .   A d d i n g   X ,   Y   o r   Z   t o   t h e   b e g i n n i n g   w o u l d   b e   a c c e p t a b l e .� �����
�� 
disp� m  ����
�� stic    ��  ��  ��  }  S  ����  < R      ������
�� .ascrerr ****      � ****��  ��  = I ������
�� .sysodlogaskr        TEXT� m  ���� ��� L N u m b e r s   a r e   n o t   a l l o w e d   f o r   t h e   p r e f i x� �����
�� 
disp� m  ����
�� stic    ��  ��   ��� l ����������  ��  ��  � ��� l ����������  ��  ��  � ��� l ��������  � / ) end of setup  //////////////////////////   � ��� R   e n d   o f   s e t u p     / / / / / / / / / / / / / / / / / / / / / / / / / /� ��� l ����������  ��  ��  � ��� I �6����
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
old_prefix  � m  {~�� ���  � ��� k  ���� ��� r  ����� m  ���� ���  R E S U B M I T� o      ���� 0 buttonpressed buttonPressed� ���� I ����� 
�� .sysodlogaskr        TEXT� m  �� � � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s .  ����
�� 
disp m  ����
�� stic    ��  ��  �  = �� o  ������ 0 
new_prefix   m  �� �		   
��
 k  ��  r  �� m  �� �  R E S U B M I T o      ���� 0 buttonpressed buttonPressed �� I ����
�� .sysodlogaskr        TEXT m  �� � � E r r o r   -   o n e   o r   m o r e   e n t r i e s   w a s   n u l l   -   p l e a s e   r e d o   y o u r   a n s w e r s . ����
�� 
disp m  ����
�� stic    ��  ��  ��  ��  � ; 5 this checks to see if any answers were a null string   � � j   t h i s   c h e c k s   t o   s e e   i f   a n y   a n s w e r s   w e r e   a   n u l l   s t r i n g��  ��  � �� l ����������  ��  ��  ��  � =  ( / o   ( +���� 0 buttonpressed buttonPressed m   + . �  R E S U B M I T��  ��  �  l     ��~�}�  �~  �}    !  l ��"�|�{" Z  ��#$�z�y# = ��%&% o  ���x�x 0 buttonpressed buttonPressed& m  ��'' �((  E X I T$ l ��)*+) L  ���w�w  * $  abort program by user request   + �,, <   a b o r t   p r o g r a m   b y   u s e r   r e q u e s t�z  �y  �|  �{  ! -.- l     �v�u�t�v  �u  �t  . /0/ l     �s12�s  1  ////// end of User Input   2 �33 0 / / / / / /   e n d   o f   U s e r   I n p u t0 454 l     �r�q�p�r  �q  �p  5 676 l     �o�n�m�o  �n  �m  7 898 l     �l:;�l  : / ) Duplicate original Xcode project folder    ; �<< R   D u p l i c a t e   o r i g i n a l   X c o d e   p r o j e c t   f o l d e r  9 =>= l ��?�k�j? O  ��@A@ r  ��BCB I ���iD�h
�i .coreclon****      � ****D o  ���g�g 0 	thefolder 	theFolder�h  C o      �f�f 0 	newfolder 	newFolderA m  ��EE�                                                                                  MACS  alis    \  JHRM                       ϓr�H+     /
Finder.app                                                      (�|��        ����  	                CoreServices    ϓ�;      �|��       /   ,   +  .JHRM:System: Library: CoreServices: Finder.app   
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  �k  �j  > FGF l     �e�d�c�e  �d  �c  G HIH l     �bJK�b  J = 7 set POSIX path for duplicated Folder for shell scripts   K �LL n   s e t   P O S I X   p a t h   f o r   d u p l i c a t e d   F o l d e r   f o r   s h e l l   s c r i p t sI MNM l �O�a�`O r  �PQP c  ��RSR b  ��TUT b  ��VWV o  ���_�_ 0 myhome myHomeW o  ���^�^  0 oldprojectname oldProjectNameU m  ��XX �YY    c o p y /S m  ���]
�] 
TEXTQ o      �\�\ 0 mypath myPath�a  �`  N Z[Z l     �[�Z�Y�[  �Z  �Y  [ \]\ l     �X^_�X  ^   create new project   _ �`` &   c r e a t e   n e w   p r o j e c t] aba l     �Wcd�W  c ) # Launch ProgBar for the first time.   d �ee F   L a u n c h   P r o g B a r   f o r   t h e   f i r s t   t i m e .b fgf l 
h�V�Uh n  
iji I  
�T�S�R�T 0 startprogbar startProgBar�S  �R  j  f  �V  �U  g klk l     �Q�P�O�Q  �P  �O  l mnm l 	�opqo O  	�rsr k  	�tt uvu l �N�M�L�N  �M  �L  v wxw l �Kyz�K  y U O clean out duplicated project build folder before making list of project items    z �{{ �   c l e a n   o u t   d u p l i c a t e d   p r o j e c t   b u i l d   f o l d e r   b e f o r e   m a k i n g   l i s t   o f   p r o j e c t   i t e m s  x |}| r  ~~ c  ��� o  �J�J 0 	newfolder 	newFolder� m  �I
�I 
ctxt o      �H�H 0 mybuildpath myBuildPath} ��� r  ,��� c  (��� b  $��� o   �G�G 0 mybuildpath myBuildPath� m   #�� ��� 
 b u i l d� m  $'�F
�F 
alis� o      �E�E 0 mybuildpath myBuildPath� ��� Z  -M���D�C� > -;��� l -8��B�A� I -8�@��
�@ .earslfdrutxt  @    file� o  -0�?�? 0 mybuildpath myBuildPath� �>��=
�> 
lfiv� m  34�<
�< boovfals�=  �B  �A  � J  8:�;�;  � I >I�:��9
�: .coredeloobj        obj � n  >E��� 2 AE�8
�8 
cobj� o  >A�7�7 0 mybuildpath myBuildPath�9  �D  �C  � ��� l NN�6�5�4�6  �5  �4  � ��� l NN�3���3  � I C Make a list of all file names in project folder and the subfolders   � ��� �   M a k e   a   l i s t   o f   a l l   f i l e   n a m e s   i n   p r o j e c t   f o l d e r   a n d   t h e   s u b f o l d e r s� ��� r  No��� b  Nk��� l NZ��2�1� e  NZ�� n  NZ��� 1  UY�0
�0 
pnam� n NU��� 2  QU�/
�/ 
file� o  NQ�.�. 0 	newfolder 	newFolder�2  �1  � l Zj��-�,� e  Zj�� n  Zj��� 1  ei�+
�+ 
pnam� n  Ze��� 2  ae�*
�* 
file� n Za��� 2  ]a�)
�) 
cfol� o  Z]�(�( 0 	newfolder 	newFolder�-  �,  � o      �'�' 0 filelist fileList� ��� I pw�&��%
�& .corecnte****       ****� 1  ps�$
�$ 
rslt�%  � ��� l x���� r  x��� 1  x{�#
�# 
rslt� o      �"�" 0 numfiles numFiles�   using result of count!   � ��� .   u s i n g   r e s u l t   o f   c o u n t !� ��� l ���!���!  �   prepare Progress Bar   � ��� *   p r e p a r e   P r o g r e s s   B a r� ��� n  ����� I  ��� ���   0 prepareprogbar prepareProgBar� ��� o  ���� 0 numfiles numFiles� ��� m  ���� �  �  �  f  ��� ��� l ������  � 2 , Open the desired Progress Bar window style.   � ��� X   O p e n   t h e   d e s i r e d   P r o g r e s s   B a r   w i n d o w   s t y l e .� ��� n  ����� I  ������ 0 fadeinprogbar fadeinProgBar� ��� m  ���� �  �  �  f  ��� ��� l ������  �  �  � ��� l ������  �  �  � ��� l ������  � 8 2 rename prefixes and file names of project files     � ��� d   r e n a m e   p r e f i x e s   a n d   f i l e   n a m e s   o f   p r o j e c t   f i l e s    � ��� Y  �	������� k  �	��� ��� l ������  �  �  � ��� l ���
���
  � z t Increment the ProgBar window's progress bar. The 'n' variable contains a number, which is the number item currently   � ��� �   I n c r e m e n t   t h e   P r o g B a r   w i n d o w ' s   p r o g r e s s   b a r .   T h e   ' n '   v a r i a b l e   c o n t a i n s   a   n u m b e r ,   w h i c h   i s   t h e   n u m b e r   i t e m   c u r r e n t l y� ��� l ���	���	  � * $ being processed by the repeat loop.   � ��� H   b e i n g   p r o c e s s e d   b y   t h e   r e p e a t   l o o p .� ��� n  ����� I  ������ $0 incrementprogbar incrementProgBar� ��� o  ���� 0 n  � ��� o  ���� 0 numfiles numFiles� ��� m  ���� �  �  �  f  ��� ��� l ����� �  �  �   � ��� l ����������  ��  ��  �    r  �� l ������ e  �� n  �� 4  ����
�� 
cobj o  ������ 0 n   o  ������ 0 filelist fileList��  ��   o      ���� 0 currentfile currentFile 	
	 l ����������  ��  ��  
 �� Z  �	��� C  �� o  ������ 0 currentfile currentFile o  ������ 0 
old_prefix   k  ��  l ����������  ��  ��    Z  ���� H  �� C  �� o  ������ 0 currentfile currentFile o  ������  0 oldprojectname oldProjectName l �n k  �n  !  l ����"#��  " 8 2 extract filename without prefix from current File   # �$$ d   e x t r a c t   f i l e n a m e   w i t h o u t   p r e f i x   f r o m   c u r r e n t   F i l e! %&% r  ��'(' m  ��)) �**  ( o      ���� 0 filename_kernel  & +,+ Y  ��-��./��- r  ��010 b  ��232 o  ������ 0 filename_kernel  3 l ��4����4 n  ��565 4  ����7
�� 
cobj7 o  ������ 0 n  6 o  ������ 0 currentfile currentFile��  ��  1 o      ���� 0 filename_kernel  �� 0 n  . o  ������ 0 kernel_beginning  / l ��8����8 I ����9��
�� .corecnte****       ****9 o  ������ 0 currentfile currentFile��  ��  ��  ��  , :;: l ����<=��  < 1 + add new prefix to filename of current File   = �>> V   a d d   n e w   p r e f i x   t o   f i l e n a m e   o f   c u r r e n t   F i l e; ?@? O �ABA r  CDC l E����E I ��F��
�� .coredoexbool       obj F l G����G n  HIH 4  ��J
�� 
fileJ o  	���� 0 currentfile currentFileI o  ���� 0 	newfolder 	newFolder��  ��  ��  ��  ��  D o      ���� "0 myfileexisthere myFileExistHereB m  � KK�                                                                                  sevs  alis    z  JHRM                       ϓr�H+     /System Events.app                                               �M�P�~        ����  	                CoreServices    ϓ�;      �Q&�       /   ,   +  5JHRM:System: Library: CoreServices: System Events.app   $  S y s t e m   E v e n t s . a p p  
  J H R M  -System/Library/CoreServices/System Events.app   / ��  @ L��L Z  nMN��OM o  ���� "0 myfileexisthere myFileExistHereN k  LPP QRQ n 5STS I  5��U���� &0 replacetextinfile replaceTextInFileU VWV o  !���� 0 currentfile currentFileW XYX o  !&����  0 oldprojectname oldProjectNameY Z[Z o  &)����  0 newprojectname newProjectName[ \]\ o  ),���� 0 
old_prefix  ] ^��^ o  ,/���� 0 
new_prefix  ��  ��  T  f  R _��_ r  6L`a` l 6=b����b b  6=cdc o  69���� 0 
new_prefix  d o  9<���� 0 filename_kernel  ��  ��  a n      efe 1  GK��
�� 
pnamf n  =Gghg 4  @G��i
�� 
docfi o  CF���� 0 currentfile currentFileh o  =@���� 0 	newfolder 	newFolder��  ��  O l Onjklj r  Onmnm l OVo����o b  OVpqp o  OR���� 0 
new_prefix  q o  RU���� 0 filename_kernel  ��  ��  n n      rsr 1  im��
�� 
pnams n  Vitut 4  bi��v
�� 
docfv o  eh���� 0 currentfile currentFileu n  Vbwxw 4  Yb��y
�� 
cfoly o  \a���� 0 	nibfolder 	nibFolderx o  VY���� 0 	newfolder 	newFolderk #  it must be in the nib Folder   l �zz :   i t   m u s t   b e   i n   t h e   n i b   F o l d e r��   : 4 if user did not start project name with the prefix!    �{{ h   i f   u s e r   d i d   n o t   s t a r t   p r o j e c t   n a m e   w i t h   t h e   p r e f i x !��   l q�|}~| Z  q����� D  qx��� o  qt���� 0 currentfile currentFile� m  tw�� ���  . x c o d e p r o j� l {����� r  {���� b  {���� o  {~����  0 newprojectname newProjectName� m  ~��� ���  . x c o d e p r o j� n      ��� 1  ����
�� 
pnam� n  ����� 4  �����
�� 
docf� o  ������ 0 currentfile currentFile� o  ������ 0 	newfolder 	newFolder� A ; non-special case were project name does not include prefix   � ��� v   n o n - s p e c i a l   c a s e   w e r e   p r o j e c t   n a m e   d o e s   n o t   i n c l u d e   p r e f i x� ��� D  ����� o  ������ 0 currentfile currentFile� m  ���� ���  . p c h� ��� r  ����� b  ����� o  ������  0 newprojectname newProjectName� m  ���� ���  _ P r e f i x . p c h� n      ��� 1  ����
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
new_prefix  ��  ��  �  f  � ���� Z  *}������ = *7��� o  *-���� 0 currentfile currentFile� l -6������ b  -6��� o  -2��  0 oldprojectname oldProjectName� m  25�� ���  . h��  ��  � l :P���� r  :P��� b  :A�	 � o  :=�~�~  0 newprojectname newProjectName	  m  =@		 �		  . h� n      			 1  KO�}
�} 
pnam	 n  AK			 4  DK�|	
�| 
docf	 o  GJ�{�{ 0 currentfile currentFile	 o  AD�z�z 0 	newfolder 	newFolder�    should only happen once		   � �		 4   s h o u l d   o n l y   h a p p e n   o n c e 	 	� 			
		 = S`			 o  SV�y�y 0 currentfile currentFile	 l V_	�x�w	 b  V_			 o  V[�v�v  0 oldprojectname oldProjectName	 m  [^		 �		  _ P r e f i x . h�x  �w  	
 	�u	 l cy				 r  cy			 b  cj			 o  cf�t�t  0 newprojectname newProjectName	 m  fi		 �		  _ P r e f i x . h	 n      			 1  tx�s
�s 
pnam	 n  jt			 4  mt�r	 
�r 
docf	  o  ps�q�q 0 currentfile currentFile	 o  jm�p�p 0 	newfolder 	newFolder	   should only happen once	   	 �	!	! 2   s h o u l d   o n l y   h a p p e n   o n c e 	�u  ��  ��  � 	"	#	" =  ��	$	%	$ o  ���o�o 0 currentfile currentFile	% b  ��	&	'	& o  ���n�n  0 oldprojectname oldProjectName	' m  ��	(	( �	)	)  . n i b	# 	*	+	* k  ��	,	, 	-	.	- r  ��	/	0	/ b  ��	1	2	1 o  ���m�m  0 newprojectname newProjectName	2 m  ��	3	3 �	4	4  . n i b	0 n      	5	6	5 1  ���l
�l 
pnam	6 n  ��	7	8	7 4  ���k	9
�k 
docf	9 o  ���j�j 0 currentfile currentFile	8 n  ��	:	;	: 4  ���i	<
�i 
cfol	< o  ���h�h 0 	nibfolder 	nibFolder	; o  ���g�g 0 	newfolder 	newFolder	. 	=�f	= l ���e	>	?�e  	>       	? �	@	@     �f  	+ 	A	B	A D  ��	C	D	C o  ���d�d 0 currentfile currentFile	D m  ��	E	E �	F	F  . p l i s t	B 	G�c	G k  ��	H	H 	I	J	I r  ��	K	L	K m  ��	M	M �	N	N  . p l i s t	L o      �b�b 0 
filesuffix 
fileSuffix	J 	O	P	O n ��	Q	R	Q I  ���a	S�`�a &0 replacetextinfile replaceTextInFile	S 	T	U	T o  ���_�_ 0 currentfile currentFile	U 	V	W	V o  ���^�^  0 oldprojectname oldProjectName	W 	X	Y	X o  ���]�]  0 newprojectname newProjectName	Y 	Z	[	Z o  ���\�\ 0 
old_prefix  	[ 	\�[	\ o  ���Z�Z 0 
new_prefix  �[  �`  	R  f  ��	P 	]	^	] r  ��	_	`	_ I ���Y	a�X
�Y .sysoctonshor       TEXT	a l ��	b�W�V	b n  ��	c	d	c 4 ���U	e
�U 
cobj	e m  ���T�T 	d o  ���S�S  0 oldprojectname oldProjectName�W  �V  �X  	` o      �R�R 0 testchar testChar	^ 	f	g	f Z  �U	h	i�Q�P	h F  �		j	k	j @  ��	l	m	l o  ���O�O 0 testchar testChar	m m  ���N�N A	k B  �	n	o	n o  ��M�M 0 testchar testChar	o m  �L�L Z	i l Q	p	q	r	p k  Q	s	s 	t	u	t r  	v	w	v m  	x	x �	y	y  	w o      �K�K 
0 locase  	u 	z	{	z Y  =	|�J	}	~�I	| r  &8		�	 b  &4	�	�	� o  &)�H�H 
0 locase  	� l )3	��G�F	� n  )3	�	�	� 4  .3�E	�
�E 
cobj	� o  12�D�D 0 n  	� o  ).�C�C  0 oldprojectname oldProjectName�G  �F  	� o      �B�B 
0 locase  �J 0 n  	} m  �A�A 	~ l !	��@�?	� I !�>	��=
�> .corecnte****       ****	� o  �<�<  0 oldprojectname oldProjectName�=  �@  �?  �I  	{ 	��;	� r  >Q	�	�	� b  >M	�	�	� l >I	��:�9	� I >I�8	��7
�8 .sysontocTEXT       shor	� l >E	��6�5	� [  >E	�	�	� o  >A�4�4 0 testchar testChar	� m  AD�3�3  �6  �5  �7  �:  �9  	� o  IL�2�2 
0 locase  	� o      �1�1 
0 locase  �;  	q   is it uppercase ?   	r �	�	� $   i s   i t   u p p e r c a s e   ?�Q  �P  	g 	�	�	� l Vd	�	�	�	� n Vd	�	�	� I  Wd�0	��/�0 &0 simplereplacetext simpleReplaceText	� 	�	�	� o  WZ�.�. 0 currentfile currentFile	� 	�	�	� o  Z]�-�- 
0 locase  	� 	��,	� o  ]`�+�+  0 newprojectname newProjectName�,  �/  	�  f  VW	� 7 1 catch any lowercase instances of project name 		   	� �	�	� b   c a t c h   a n y   l o w e r c a s e   i n s t a n c e s   o f   p r o j e c t   n a m e   	 		� 	�	�	� l ee�*	�	��*  	� ; 5 rename only .plist files containing the projectname    	� �	�	� j   r e n a m e   o n l y   . p l i s t   f i l e s   c o n t a i n i n g   t h e   p r o j e c t n a m e  	� 	��)	� r  e�	�	�	� l e�	��(�'	� I e��&	�	��& 0 searchreplace searchReplace	�  f  ef	� �%	�	�
�% 
into	� o  il�$�$ 0 currentfile currentFile	� �#	�	�
�# 
at  	� o  ot�"�"  0 oldprojectname oldProjectName	� �!	�� �! 0 replacestring replaceString	� o  wz��  0 newprojectname newProjectName�   �(  �'  	� n      	�	�	� 1  ���
� 
pnam	� n  ��	�	�	� 4  ���	�
� 
docf	� o  ���� 0 currentfile currentFile	� o  ���� 0 	newfolder 	newFolder�)  �c  ��  } � � SPECIAL CASE! project name includes original prefix - only check file once so need code redundancy here -- furture create function instead?   ~ �	�	�   S P E C I A L   C A S E !   p r o j e c t   n a m e   i n c l u d e s   o r i g i n a l   p r e f i x   -   o n l y   c h e c k   f i l e   o n c e   s o   n e e d   c o d e   r e d u n d a n c y   h e r e   - -   f u r t u r e   c r e a t e   f u n c t i o n   i n s t e a d ? 	��	� l ������  �  �  �  ��   l �	�	�	�	�	� Z  �	�	�	�	��	� D  ��	�	�	� o  ���� 0 currentfile currentFile	� m  ��	�	� �	�	�  . x c o d e p r o j	� l ��	�	�	�	� r  ��	�	�	� b  ��	�	�	� o  ����  0 newprojectname newProjectName	� m  ��	�	� �	�	�  . x c o d e p r o j	� n      	�	�	� 1  ���
� 
pnam	� n  ��	�	�	� 4  ���	�
� 
docf	� o  ���� 0 currentfile currentFile	� o  ���� 0 	newfolder 	newFolder	� B < non-special case where project name does not include prefix   	� �	�	� x   n o n - s p e c i a l   c a s e   w h e r e   p r o j e c t   n a m e   d o e s   n o t   i n c l u d e   p r e f i x	� 	�	�	� D  ��	�	�	� o  ���� 0 currentfile currentFile	� m  ��	�	� �	�	�  . p c h	� 	�	�	� r  ��	�	�	� b  ��	�	�	� o  ����  0 newprojectname newProjectName	� m  ��	�	� �	�	�  _ P r e f i x . p c h	� n      	�	�	� 1  ���
� 
pnam	� n  ��	�	�	� 4  ���	�
� 
docf	� o  ���� 0 currentfile currentFile	� o  ���
�
 0 	newfolder 	newFolder	� 	�	�	� D  ��	�	�	� o  ���	�	 0 currentfile currentFile	� m  ��	�	� �	�	�  . m	� 	�	�	� k  �+	�	� 	�	�	� n � 	�	�	� I  � �	��� &0 replacetextinfile replaceTextInFile	� 	�	�	� o  ���� 0 currentfile currentFile	� 	�	�	� o  ����  0 oldprojectname oldProjectName	� 	�	�	� o  ����  0 newprojectname newProjectName	� 	�	�	� o  ���� 0 
old_prefix  	� 	��	� o  ���� 0 
new_prefix  �  �  	�  f  ��	� 	�� 	� Z  +	�	�����	� = 	�
 	� o  ���� 0 currentfile currentFile
  l 
����
 b  


 o  	����  0 oldprojectname oldProjectName
 m  	

 �

  . m��  ��  	� l '



 r  '
	


	 b  


 o  ����  0 newprojectname newProjectName
 m  

 �

  . m

 n      


 1  "&��
�� 
pnam
 n  "


 4  "��

�� 
docf
 o  !���� 0 currentfile currentFile
 o  ���� 0 	newfolder 	newFolder
   should only happen once   
 �

 0   s h o u l d   o n l y   h a p p e n   o n c e��  ��  �   	� 


 D  .5


 o  .1���� 0 currentfile currentFile
 m  14

 �

  . h
 


 k  8�

 


 n 8P
 
!
  I  9P��
"���� &0 replacetextinfile replaceTextInFile
" 
#
$
# o  9<���� 0 currentfile currentFile
$ 
%
&
% o  <A����  0 oldprojectname oldProjectName
& 
'
(
' o  AD����  0 newprojectname newProjectName
( 
)
*
) o  DG���� 0 
old_prefix  
* 
+��
+ o  GJ���� 0 
new_prefix  ��  ��  
!  f  89
 
,��
, Z  Q�
-
.
/��
- = Q^
0
1
0 o  QT���� 0 currentfile currentFile
1 l T]
2����
2 b  T]
3
4
3 o  TY����  0 oldprojectname oldProjectName
4 m  Y\
5
5 �
6
6  . h��  ��  
. l aw
7
8
9
7 r  aw
:
;
: b  ah
<
=
< o  ad����  0 newprojectname newProjectName
= m  dg
>
> �
?
?  . h
; n      
@
A
@ 1  rv��
�� 
pnam
A n  hr
B
C
B 4  kr��
D
�� 
docf
D o  nq���� 0 currentfile currentFile
C o  hk���� 0 	newfolder 	newFolder
8    should only happen once		   
9 �
E
E 4   s h o u l d   o n l y   h a p p e n   o n c e 	 	
/ 
F
G
F = z�
H
I
H o  z}���� 0 currentfile currentFile
I l }�
J����
J b  }�
K
L
K o  }�����  0 oldprojectname oldProjectName
L m  ��
M
M �
N
N  _ P r e f i x . h��  ��  
G 
O��
O l ��
P
Q
R
P r  ��
S
T
S b  ��
U
V
U o  ������  0 newprojectname newProjectName
V m  ��
W
W �
X
X  _ P r e f i x . h
T n      
Y
Z
Y 1  ����
�� 
pnam
Z n  ��
[
\
[ 4  ����
]
�� 
docf
] o  ������ 0 currentfile currentFile
\ o  ������ 0 	newfolder 	newFolder
Q   should only happen once	   
R �
^
^ 2   s h o u l d   o n l y   h a p p e n   o n c e 	��  ��  ��  
 
_
`
_ =  ��
a
b
a o  ������ 0 currentfile currentFile
b b  ��
c
d
c o  ������  0 oldprojectname oldProjectName
d m  ��
e
e �
f
f  . n i b
` 
g
h
g k  ��
i
i 
j
k
j r  ��
l
m
l b  ��
n
o
n o  ������  0 newprojectname newProjectName
o m  ��
p
p �
q
q  . n i b
m n      
r
s
r 1  ����
�� 
pnam
s n  ��
t
u
t 4  ����
v
�� 
docf
v o  ������ 0 currentfile currentFile
u n  ��
w
x
w 4  ����
y
�� 
cfol
y o  ������ 0 	nibfolder 	nibFolder
x o  ������ 0 	newfolder 	newFolder
k 
z
{
z l ����������  ��  ��  
{ 
|��
| l ����
}
~��  
}       
~ �

     ��  
h 
�
�
� D  ��
�
�
� o  ������ 0 currentfile currentFile
� m  ��
�
� �
�
�  . p l i s t
� 
���
� k  �	�
�
� 
�
�
� r  ��
�
�
� m  ��
�
� �
�
�  . p l i s t
� o      ���� 0 
filesuffix 
fileSuffix
� 
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
� o  	�	��� 0 	newfolder 	newFolder��  ��  �  	� 5 / handle special cases of files without prefixes   	� �
�
� ^   h a n d l e   s p e c i a l   c a s e s   o f   f i l e s   w i t h o u t   p r e f i x e s��  � 0 n  � m  ���~�~ � o  ���}�} 0 numfiles numFiles�  � 
�
�
� l 	�	��|�{�z�|  �{  �z  
� 
�
�
� l 	�	��y
�
��y  
� : 4 finally rename duplicate folder to new project name   
� �
�
� h   f i n a l l y   r e n a m e   d u p l i c a t e   f o l d e r   t o   n e w   p r o j e c t   n a m e
� 
�
�
� r  	�	�   o  	�	��x�x  0 newprojectname newProjectName n       1  	�	��w
�w 
pnam o  	�	��v�v 0 	newfolder 	newFolder
�  l 	�	��u�t�s�u  �t  �s    l 	�	��r	�r   I C Conclude the progress bar. This 'resets' the progress bar's state.   	 �

 �   C o n c l u d e   t h e   p r o g r e s s   b a r .   T h i s   ' r e s e t s '   t h e   p r o g r e s s   b a r ' s   s t a t e .  n  	�	� I  	�	��q�p�o�q 0 stopprogbar stopProgBar�p  �o    f  	�	� �n l 	�	��m�l�k�m  �l  �k  �n  s m  �                                                                                  MACS  alis    \  JHRM                       ϓr�H+     /
Finder.app                                                      (�|��        ����  	                CoreServices    ϓ�;      �|��       /   ,   +  .JHRM:System: Library: CoreServices: Finder.app   
 F i n d e r . a p p  
  J H R M  &System/Library/CoreServices/Finder.app  / ��  p 0 * end finder script for renaming everything   q � T   e n d   f i n d e r   s c r i p t   f o r   r e n a m i n g   e v e r y t h i n gn  l     �j�i�h�j  �i  �h    l     �g�g   � z Go into Project .xcodeproj package and replace all prefixes and names to fix broken links within xcode paths and targets     � �   G o   i n t o   P r o j e c t   . x c o d e p r o j   p a c k a g e   a n d   r e p l a c e   a l l   p r e f i x e s   a n d   n a m e s   t o   f i x   b r o k e n   l i n k s   w i t h i n   x c o d e   p a t h s   a n d   t a r g e t s    l 	�	��f�e r  	�	� c  	�	� b  	�	� !  b  	�	�"#" b  	�	�$%$ b  	�	�&'& o  	�	��d�d 0 myhome myHome' o  	�	��c�c  0 newprojectname newProjectName% m  	�	�(( �))  /# o  	�	��b�b  0 newprojectname newProjectName! m  	�	�** �++  . x c o d e p r o j m  	�	��a
�a 
TEXT o      �`�` 0 mypath myPath�f  �e   ,-, l 	�	�./0. r  	�	�121 m  	�	�33 �44  . p b x p r o j2 o      �_�_ 0 
filesuffix 
fileSuffix/   set global variable   0 �55 (   s e t   g l o b a l   v a r i a b l e- 676 l     �^�]�\�^  �]  �\  7 898 l 	�
:�[�Z: I  	�
�Y;�X�Y &0 simplereplacetext simpleReplaceText; <=< m  	�
>> �??  p r o j e c t . p b x p r o j= @A@ o  

�W�W  0 oldprojectname oldProjectNameA B�VB o  

	�U�U  0 newprojectname newProjectName�V  �X  �[  �Z  9 CDC l     �T�S�R�T  �S  �R  D EFE l     �QGH�Q  G _ Y --------more detailed search of project file structure to prevent incorrect replacements   H �II �   - - - - - - - - m o r e   d e t a i l e d   s e a r c h   o f   p r o j e c t   f i l e   s t r u c t u r e   t o   p r e v e n t   i n c o r r e c t   r e p l a c e m e n t sF JKJ l 

L�P�OL r  

MNM c  

OPO b  

QRQ m  

SS �TT  p a t h   =  R o  

�N�N 0 
old_prefix  P m  

�M
�M 
TEXTN o      �L�L 0 pathoprefix  �P  �O  K UVU l 

-W�K�JW r  

-XYX c  

)Z[Z b  

%\]\ m  

!^^ �__  p a t h   =  ] o  
!
$�I�I 0 
new_prefix  [ m  
%
(�H
�H 
TEXTY o      �G�G 0 pathnprefix  �K  �J  V `a` l 
.
<b�F�Eb I  
.
<�Dc�C�D &0 simplereplacetext simpleReplaceTextc ded m  
/
2ff �gg  p r o j e c t . p b x p r o je hih o  
2
5�B�B 0 pathoprefix  i j�Aj o  
5
8�@�@ 0 pathnprefix  �A  �C  �F  �E  a klk l     �?�>�=�?  �>  �=  l mnm l 
=
Lo�<�;o r  
=
Lpqp c  
=
Hrsr b  
=
Dtut m  
=
@vv �ww  n a m e   =  u o  
@
C�:�: 0 
old_prefix  s m  
D
G�9
�9 
TEXTq o      �8�8 0 nameoprefix  �<  �;  n xyx l 
M
\z�7�6z r  
M
\{|{ c  
M
X}~} b  
M
T� m  
M
P�� ���  n a m e   =  � o  
P
S�5�5 0 
new_prefix  ~ m  
T
W�4
�4 
TEXT| o      �3�3 0 namenprefix  �7  �6  y ��� l 
]
k��2�1� I  
]
k�0��/�0 &0 simplereplacetext simpleReplaceText� ��� m  
^
a�� ���  p r o j e c t . p b x p r o j� ��� o  
a
d�.�. 0 nameoprefix  � ��-� o  
d
g�,�, 0 namenprefix  �-  �/  �2  �1  � ��� l     �+�*�)�+  �*  �)  � ��� l 
l
{��(�'� r  
l
{��� c  
l
w��� b  
l
s��� m  
l
o�� ���  H E A D E R   =  � o  
o
r�&�& 0 
old_prefix  � m  
s
v�%
�% 
TEXT� o      �$�$ 0 nameoprefix  �(  �'  � ��� l 
|
���#�"� r  
|
���� c  
|
���� b  
|
���� m  
|
�� ���  H E A D E R   =  � o  

��!�! 0 
new_prefix  � m  
�
�� 
�  
TEXT� o      �� 0 namenprefix  �#  �"  � ��� l 
�
����� I  
�
����� &0 simplereplacetext simpleReplaceText� ��� m  
�
��� ���  p r o j e c t . p b x p r o j� ��� o  
�
��� 0 nameoprefix  � ��� o  
�
��� 0 namenprefix  �  �  �  �  � ��� l     ����  �  �  � ��� l 
�
����� r  
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
��� 0 	nibfolder 	nibFolder� m  
�
��� ���  \ /� o  
�
��� 0 
old_prefix  � m  
�
��
� 
TEXT� o      �� 0 nibpathoprefix  �  �  � ��� l 
�
����� r  
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
��� 0 	nibfolder 	nibFolder� m  
�
��� ���  \ /� o  
�
��� 0 
new_prefix  � m  
�
��

�
 
TEXT� o      �	�	 0 nibpathnprefix  �  �  � ��� l 
�
����� I  
�
����� &0 simplereplacetext simpleReplaceText� ��� m  
�
��� ���  p r o j e c t . p b x p r o j� ��� o  
�
��� 0 nibpathoprefix  � ��� o  
�
��� 0 nibpathnprefix  �  �  �  �  � ��� l     �� ���  �   ��  � ��� l 
�
������� r  
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
����� 0 	nibfolder 	nibFolder� m  
�
��� ���  \ /� o  
�
����� 0 
old_prefix  � m  
�
���
�� 
TEXT� o      ���� 0 nibpathoprefix  ��  ��  � ��� l 
������� r  
���� c  
���� b  
�	��� b  
���� b  
���� m  
�
�   �  n a m e   =  � o  
� ���� 0 	nibfolder 	nibFolder� m   �  \ /� o  ���� 0 
new_prefix  � m  	��
�� 
TEXT� o      ���� 0 nibpathnprefix  ��  ��  �  l  ���� I   ������ &0 simplereplacetext simpleReplaceText 	 m  

 �  p r o j e c t . p b x p r o j	  o  ���� 0 nibpathoprefix   �� o  ���� 0 nibpathnprefix  ��  ��  ��  ��    l     ��������  ��  ��    l     ��������  ��  ��    l     ����     clean new project    � $   c l e a n   n e w   p r o j e c t  l !6���� r  !6 c  !0 b  !,  b  !(!"! o  !$���� 0 myhome myHome" o  $'����  0 newprojectname newProjectName  m  (+## �$$  / m  ,/��
�� 
TEXT o      ���� 0 mypath myPath��  ��   %&% l 7V'()' r  7V*+* l 7R,����, I 7R����-�� 0 searchreplace searchReplace��  - ��./
�� 
into. o  ;@���� 0 mypath myPath/ ��01
�� 
at  0 l CF2����2 m  CF33 �44   ��  ��  1 ��5���� 0 replacestring replaceString5 m  IL66 �77  \ %��  ��  ��  + o      ���� 0 	shellpath 	ShellPath( H B uses global variable to overcome POSIX issue with spaces in names   ) �88 �   u s e s   g l o b a l   v a r i a b l e   t o   o v e r c o m e   P O S I X   i s s u e   w i t h   s p a c e s   i n   n a m e s& 9:9 l Wt;����; r  Wt<=< l Wp>����> I Wp����?�� 0 searchreplace searchReplace��  ? ��@A
�� 
into@ o  [^���� 0 	shellpath 	ShellPathA ��BC
�� 
at  B m  adDD �EE  %C ��F���� 0 replacestring replaceStringF m  gjGG �HH   ��  ��  ��  = o      ���� 0 	shellpath 	ShellPath��  ��  : IJI l u�KLMK r  u�NON b  u�PQP b  u|RSR m  uxTT �UU  r m  S o  x{���� 0 	shellpath 	ShellPathQ o  |����� &0 replacescriptname replaceScriptNameO o      ���� 0 cmd  L 5 / remove sed script file from new project folder   M �VV ^   r e m o v e   s e d   s c r i p t   f i l e   f r o m   n e w   p r o j e c t   f o l d e rJ WXW l ��Y����Y I ����Z��
�� .sysoexecTEXT���     TEXTZ o  ������ 0 cmd  ��  ��  ��  X [\[ l ��]����] r  ��^_^ b  ��`a` b  ��bcb m  ��dd �ee  c d  c o  ������ 0 	shellpath 	ShellPatha m  ��ff �gg < ;   x c o d e b u i l d   - a l l t a r g e t s   c l e a n_ o      ���� 0 cmd  ��  ��  \ hih l ��j����j I ����k��
�� .sysoexecTEXT���     TEXTk o  ������ 0 cmd  ��  ��  ��  i lml l     ��������  ��  ��  m non l     ��pq��  p   end of copyXproject   q �rr (   e n d   o f   c o p y X p r o j e c to sts l ��u����u I ��������
�� .miscactvnull��� ��� null��  ��  ��  ��  t vwv l ��x����x I ����yz
�� .sysodlogaskr        TEXTy b  ��{|{ o  ������  0 newprojectname newProjectName| m  ��}} �~~ $   h a s   b e e n   c r e a t e d !z ����
�� 
disp m  ����
�� stic   ��  ��  ��  w ��� l     ��������  ��  ��  � ���� l     ��������  ��  ��  ��       R���  %��3�����������������������������������������������������������������������������������������������������~�}�|�{�z��  � P�y�x�w�v�u�t�s�r�q�p�o�n�m�l�k�j�i�h�g�f�e�d�c�b�a�`�_�^�]�\�[�Z�Y�X�W�V�U�T�S�R�Q�P�O�N�M�L�K�J�I�H�G�F�E�D�C�B�A�@�?�>�=�<�;�:�9�8�7�6�5�4�3�2�1�0�/�.�-�,�+�*�y 0 	nibfolder 	nibFolder�x &0 replacescriptname replaceScriptName�w  0 oldprojectname oldProjectName�v 0 mypath myPath�u 0 
filesuffix 
fileSuffix�t &0 replacetextinfile replaceTextInFile�s &0 simplereplacetext simpleReplaceText�r 0 searchreplace searchReplace�q 0 upcase upCase�p  0 prepareprogbar prepareProgBar�o $0 incrementprogbar incrementProgBar�n 0 fadeinprogbar fadeinProgBar�m  0 fadeoutprogbar fadeoutProgBar�l 0 showprogbar showProgBar�k 0 hideprogbar hideProgBar�j 0 
barberpole 
barberPole�i  0 killbarberpole killBarberPole�h 0 startprogbar startProgBar�g 0 stopprogbar stopProgBar
�f .aevtoappnull  �   � ****�e  0 myreservedlist myReservedList�d 0 buttonpressed buttonPressed�c 0 	thefolder 	theFolder�b 0 olddelimiter oldDelimiter�a 0 myhome myHome�` 0 totl  �_ 
0 ending  �^ 0 text_returned  �] 0 button_pressed  �\  0 newprojectname newProjectName�[ 0 
old_prefix  �Z 0 kernel_beginning  �Y 0 
new_prefix  �X 0 n  �W 0 	newfolder 	newFolder�V 0 mybuildpath myBuildPath�U 0 filelist fileList�T 0 numfiles numFiles�S 0 currentfile currentFile�R 0 testchar testChar�Q 
0 locase  �P 0 filename_kernel  �O "0 myfileexisthere myFileExistHere�N 0 pathoprefix  �M 0 pathnprefix  �L 0 nameoprefix  �K 0 namenprefix  �J 0 nibpathoprefix  �I 0 nibpathnprefix  �H 0 	shellpath 	ShellPath�G 0 cmd  �F  �E  �D  �C  �B  �A  �@  �?  �>  �=  �<  �;  �:  �9  �8  �7  �6  �5  �4  �3  �2  �1  �0  �/  �.  �-  �,  �+  �*  � ���  C r i t e r i o n� ��� Z / U s e r s / S h a r e d / L a b l i b - P l u g i n s / S i g n a l D e t e c t i o n /� �) ��(�'���&�) &0 replacetextinfile replaceTextInFile�( �%��% �  �$�#�"�!� �$ 0 thefile theFile�# 0 oldtext1  �" 0 newtext1  �! 0 oldtext2  �  0 newtext2  �'  � ������������ 0 thefile theFile� 0 oldtext1  � 0 newtext1  � 0 oldtext2  � 0 newtext2  � 0 tempfile tempFile� "0 scriptfilefound scriptFileFound� 0 filename fileName� 0 fileid fileID� 0 	shellpath 	ShellPath� 0 cmd  � 5 � ���������
���
�	�0�3��@Cy{}������������������
� 
cfol
� 
file
� .coredoexbool       obj 
� 
psxf
� 
perm
� .rdwropenshor       file� 

� .sysontocTEXT       shor
� 
refn
� .rdwrwritnull���     ****
�
 .rdwrclosnull���     ****
�	 
into
� 
at  � 0 replacestring replaceString� � 0 searchreplace searchReplace
� .sysoexecTEXT���     TEXT�&]�E�O� *�b  /�b  /j E�UO� ab  b  %E�O*�/�el E�O�%�%�%�%�j %�%�%�%�j %�%�%a %�%a %�j %a %a �l O�j Y hO*a b  a a a a a  E�O*a �a a a a a  E�Oa �%�%a  %�%�%a !%a "%�%�%a #%a $%�%a %%�%a &%�%�%a '%�%�%a (%a )%�%�%E�O�j *Oa +�%�%a ,%�%�%a -%a .%�%�%a /%a 0%�%b  %a 1%�%�%a 2%�%�%a 3%a 4%�%�%E�O�j *� ������� � &0 simplereplacetext simpleReplaceText� ����� �  �������� 0 thefile theFile�� 0 oldtext  �� 0 newtext newText�  � �������������� 0 thefile theFile�� 0 oldtext  �� 0 newtext newText�� 0 tempfile tempFile�� 0 	shellpath 	ShellPath�� 0 cmd  � �������������FHJLNPRTV��
�� 
TEXT
�� 
into
�� 
at  �� 0 replacestring replaceString�� �� 0 searchreplace searchReplace
�� .sysoexecTEXT���     TEXT�  `�b  %�&E�O*�b  ����� E�O*������ E�O�%�%�%�%�%�%�%�%�%a %�%a %�%a %�%a %�%E�O�j � ��e���������� 0 searchreplace searchReplace��  �� �����
�� 
into�� 0 
mainstring 
mainString� �����
�� 
at  �� 0 searchstring searchString� �������� 0 replacestring replaceString�� 0 replacestring replaceString��  � �������������� 0 
mainstring 
mainString�� 0 searchstring searchString�� 0 replacestring replaceString�� 0 foundoffset foundOffset�� 0 stringstart stringStart�� 0 	stringend 	stringEnd� �������������
�� 
psof
�� 
psin�� 
�� .sysooffslong    ��� null
�� 
ctxt
�� .corecnte****       ****�� T Oh��*��� E�O�k  �E�Y �[�\[Zk\Z�k2E�O�[�\[Z��j \Zi2E�O��%�%E�[OY��O�� ������������� 0 upcase upCase�� ����� �  ���� 0 astring aString��  � ���������� 0 astring aString�� 
0 buffer  �� 0 i  �� 0 testchar testChar� 	�����������������
�� .corecnte****       ****
�� 
cobj
�� .sysoctonshor       TEXT�� a�� z
�� 
bool��  
�� .sysontocTEXT       shor�� Q�E�O Hk�j kh ��/j E�O��	 ���& ���j %E�OPY ��j %E�OPOP[OY��O�� ��;����������  0 prepareprogbar prepareProgBar�� ����� �  ������ 0 somemaxcount someMaxCount�� 0 
windowname 
windowName��  � ������ 0 somemaxcount someMaxCount�� 0 
windowname 
windowName� �������������������������s������������   ��
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
maxV�� b� ^���mv*�/�,FOe*�/�,FOjm������v��/*�/�,FO�*�/�,FOj*�/�k/a ,FOj*�/�k/a ,FO�*�/�k/a ,FU� ������������� $0 incrementprogbar incrementProgBar�� ����� �  �������� 0 
itemnumber 
itemNumber�� 0 somemaxcount someMaxCount�� 0 
windowname 
windowName��  � �������� 0 
itemnumber 
itemNumber�� 0 somemaxcount someMaxCount�� 0 
windowname 
windowName� 
������������������ 0 filelist fileList
�� 
cobj
�� 
cwin
�� 
titl
�� 
proI
�� 
conT�� '� #�%�%�%�%��/%*�/�,FO�*�/�k/�,FU� ������������� 0 fadeinprogbar fadeinProgBar�� ����� �  ���� 0 
windowname 
windowName��  � �������� 0 
windowname 
windowName�� 0 	fadevalue 	fadeValue�� 0 i  � 
�����������������
�� 
cwin
�� .appScent****      � ****
�� 
alpV
�� 
pvis�� 	
�� 
proI
�� 
usTA
�� .coVSstaA****      � ****�� P� L*�/j Oj*�/�,FOe*�/�,FO�E�O j�kh �*�/�,FO��E�[OY��O*�/�k/�el 	U� ������������  0 fadeoutprogbar fadeoutProgBar�� ����� �  ���� 0 
windowname 
windowName��  � �������� 0 
windowname 
windowName�� 0 	fadevalue 	fadeValue�� 0 i  � 
I����~�}/�|�{B�z
�� 
cwin
� 
proI
�~ 
usTA
�} .coVSstoT****      � ****�| 	
�{ 
alpV
�z 
pvis�� >� :*�/�k/�el O�E�O k�kh �*�/�,FO��E�[OY��Of*�/�,FU� �yT�x�w���v�y 0 showprogbar showProgBar�x �u��u �  �t�t 0 
windowname 
windowName�w  � �s�s 0 
windowname 
windowName� m�r�q�p�o�n�m
�r 
cwin
�q .appScent****      � ****
�p 
pvis
�o 
proI
�n 
usTA
�m .coVSstaA****      � ****�v %� !*�/j Oe*�/�,FO*�/�k/�el U� �lx�k�j���i�l 0 hideprogbar hideProgBar�k �h��h �  �g�g 0 
windowname 
windowName�j  � �f�f 0 
windowname 
windowName� ��e�d�c�b�a
�e 
cwin
�d 
proI
�c 
usTA
�b .coVSstoT****      � ****
�a 
pvis�i � *�/�k/�el Of*�/�,FU� �`��_�^���]�` 0 
barberpole 
barberPole�_ �\��\ �  �[�[ 0 
windowname 
windowName�^  � �Z�Z 0 
windowname 
windowName� ��Y�X�W
�Y 
cwin
�X 
proI
�W 
indR�] � e*�/�k/�,FU� �V��U�T���S�V  0 killbarberpole killBarberPole�U �R��R �  �Q�Q 0 
windowname 
windowName�T  � �P�P 0 
windowname 
windowName� ��O�N�M
�O 
cwin
�N 
proI
�M 
indR�S � f*�/�k/�,FU� �L��K�J���I�L 0 startprogbar startProgBar�K  �J  �  � ��H
�H .ascrnoop****      � ****�I � *j U� �G��F�E���D�G 0 stopprogbar stopProgBar�F  �E  �  � ��C
�C .aevtquitnull��� ��� null�D � *j U� �B��A�@���?
�B .aevtoappnull  �   � ****� k    ���  O�� ��� ���  �� =�� M�� f�� m�� �� ,�� 8�� J�� U�� `�� m�� x�� ��� ��� ��� ��� ��� ��� ��� ��� ��� �� �� %�� 9�� I�� W�� [�� h�� s�� v�>�>  �A  �@  � �=�= 0 n  � � W [ _ c g k o s w {  � � � � � ��<�;��:�9�8�7�6�5�4�3�2�1�0�/�.1�-�,�+�*T\�)m�(q�'w�&�%�$�#�"�!� ��������������������� &���������Znq��
���������	������'E��X�������� ��������������)��K�������������������				(	3	E	M����������	x������	�	�	�	�	�



5
>
M
W
e
p
�
�
���(*3>S��^��fv�������������������� 
#36��DGT����df��}�< �;  0 myreservedlist myReservedList�: 0 buttonpressed buttonPressed
�9 
prmp
�8 .sysostflalis    ��� null
�7 
alis�6 0 	thefolder 	theFolder
�5 .sysonfo4asfe        file
�4 
pnam
�3 
ascr
�2 
txdl�1 0 olddelimiter oldDelimiter
�0 
psxp
�/ 
TEXT�. 0 myhome myHome
�- 
citm
�, .corecnte****       ****�+ 0 totl  �* 
0 ending  �)  
�( 
dtxt
�' 
btns
�& 
dflt�% 
�$ .sysodlogaskr        TEXT
�# 
rslt
�" 
list
�! 
cobj�  0 text_returned  � 0 button_pressed  �  0 newprojectname newProjectName
� 
into
� 
at  � 0 replacestring replaceString� 0 searchreplace searchReplace� 0 
old_prefix  � 0 upcase upCase� 0 kernel_beginning  
� .sysobeepnull��� ��� long
� 
disp
� stic    � 0 
new_prefix  � 0� 0 n  � 

� 
psof
� .sysontocTEXT       shor
� 
psin� 
� .sysooffslong    ��� null�
  
�	 stic   
� .coreclon****      � ****� 0 	newfolder 	newFolder� 0 startprogbar startProgBar
� 
ctxt� 0 mybuildpath myBuildPath
� 
lfiv
� .earslfdrutxt  @    file
� .coredeloobj        obj 
�  
file
�� 
cfol�� 0 filelist fileList�� 0 numfiles numFiles��  0 prepareprogbar prepareProgBar�� 0 fadeinprogbar fadeinProgBar�� $0 incrementprogbar incrementProgBar�� 0 currentfile currentFile�� 0 filename_kernel  
�� .coredoexbool       obj �� "0 myfileexisthere myFileExistHere�� �� &0 replacetextinfile replaceTextInFile
�� 
docf
�� .sysoctonshor       TEXT�� 0 testchar testChar�� A�� Z
�� 
bool�� 
0 locase  ��  �� &0 simplereplacetext simpleReplaceText�� 0 stopprogbar stopProgBar�� 0 pathoprefix  �� 0 pathnprefix  �� 0 nameoprefix  �� 0 namenprefix  �� 0 nibpathoprefix  �� 0 nibpathnprefix  �� 0 	shellpath 	ShellPath�� 0 cmd  
�� .sysoexecTEXT���     TEXT
�� .miscactvnull��� ��� null�?�����������������a a vE` Oa E` O�h_ a  *a a l a &E` O_ j a ,Ec  O p_ a ,E` O_ a  ,a !&E` "Oa #_ a ,FO_ "a $-j %E` &O_ &lE` 'O_ "[a $\[Zk\Z_ '2a !&a (%E` "O_ _ a ,FW X ) *_ _ a ,FOa +a ,a -a .a /kva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 6a !&E` 8O*a 9_ 8a :a ;a <a =a 1 >E` 8Oa ?b  %a @%a ,a Aa .a Bkva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 6a !&E` CO*a 9_ Ca :a Da <a Ea 1 >E` CO*_ Ck+ FE` CO_ Cj %kE` GO_ _ C *j HOa Ia Ja Kl 2OhY hOhZa L_ 8%a M%a ,a Na .a Okva 0ka 1 2O_ 3a 4&E[a 5k/EQ` 6Z[a 5l/EQ` 7ZO_ 6a !&E` PO �a QE` RO =a Skh*a T_ Rj Ua V_ Pa W Xj )ja YY hO_ RkE` R[OY��O*a 9_ Pa :a Za <a [a 1 >E` PO*_ Pk+ FE` PO_ _ P *j HOa \a Ja Kl 2Y W X ] *a ^a Ja Kl 2[OY� Oa _b  %a `%_ 8%a a%_ C%a b%_ P%a .a ca da emva 0ka Ja fa 1 2O_ 3a 4&E[a 5k/EQ` ZO_ a g l_ 8a h  a iE` Oa ja Ja Kl 2Y G_ Ca k  a lE` Oa ma Ja Kl 2Y %_ Pa n  a oE` Oa pa Ja Kl 2Y hY hOP[OY�bO_ a q  hY hOa r _ j sE` tUO_ "b  %a u%a !&Ec  O)j+ vOa r�_ ta w&E` xO_ xa y%a &E` xO_ xa zfl {jv _ xa 5-j |Y hO_ ta }-a ,E_ ta ~-a }-a ,E%E` O_ 3j %O_ 3E` �O)_ �kl+ �O)kk+ �O-k_ �kh  )�_ �km+ �O_ a 5�/EE` �O_ �_ C�_ �b   �a �E` �O &_ G_ �j %kh  _ �_ �a 5�/%E` �[OY��Oa � _ ta }_ �/j �E` �UO_ � 4)_ �b  _ 8_ C_ Pa �+ �O_ P_ �%_ ta �_ �/a ,FY !_ P_ �%_ ta ~b   /a �_ �/a ,FY$_ �a � _ 8a �%_ ta �_ �/a ,FY_ �a � _ 8a �%_ ta �_ �/a ,FY�_ �a � H)_ �b  _ 8_ C_ Pa �+ �O_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY hY�_ �a � q)_ �b  _ 8_ C_ Pa �+ �O_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY ,_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY hY_ �b  a �%  &_ 8a �%_ ta ~b   /a �_ �/a ,FOPY �_ �a � �a �Ec  O)_ �b  _ 8_ C_ Pa �+ �Ob  a 5k/j �E` �O_ �a �	 _ �a �a �& Ja �E` �O (lb  j %kh  _ �b  a 5�/%E` �[OY��O_ �a �j U_ �%E` �Y hO)_ �_ �_ 8m+ �O)a 9_ �a :b  a <_ 8a 1 >_ ta �_ �/a ,FY hOPY$_ �a � _ 8a �%_ ta �_ �/a ,FY_ �a � _ 8a �%_ ta �_ �/a ,FY�_ �a � H)_ �b  _ 8_ C_ Pa �+ �O_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY hY�_ �a � q)_ �b  _ 8_ C_ Pa �+ �O_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY ,_ �b  a �%  _ 8a �%_ ta �_ �/a ,FY hY_ �b  a �%  &_ 8a �%_ ta ~b   /a �_ �/a ,FOPY �_ �a � �a �Ec  O)_ �b  _ 8_ C_ Pa �+ �Ob  a 5k/j �E` �O_ �a �	 _ �a �a �& Ja �E` �O (lb  j %kh  _ �b  a 5�/%E` �[OY��O_ �a �j U_ �%E` �Y hO)_ �_ �_ 8m+ �O)a 9_ �a :b  a <_ 8a 1 >_ ta �_ �/a ,FY h[OY��O_ 8_ ta ,FO)j+ �OPUO_ "_ 8%a �%_ 8%a �%a !&Ec  Oa �Ec  O*a �b  _ 8m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �_ C%a !&E` �Oa �_ P%a !&E` �O*a �_ �_ �m+ �Oa �b   %a �%_ C%a !&E` �Oa �b   %a �%_ P%a !&E` �O*a �_ �_ �m+ �Oa �b   %a �%_ C%a !&E` �Oa �b   %a �%_ P%a !&E` �O*a �_ �_ �m+ �O_ "_ 8%a �%a !&Ec  O*a 9b  a :a �a <a �a 1 >E` �O*a 9_ �a :a �a <a �a 1 >E` �Oa �_ �%b  %E` �O_ �j �Oa �_ �%a �%E` �O_ �j �O*j �O_ 8a �%a Ja fl 2� ����� �   W [ _ c g k o s w {  � � � � � �� ���  E X I T�alis      JHRM                       ϓr�H+   +�s	Criterion                                                       +���Xy�        ����  I                 ϓ�;      �X�     	 C r i t e r i o n  
  J H R M  %Users/Shared/Lablib-Plugins/Criterion   / ��      � ����� �     �  � � : / U s e r s / S h a r e d / L a b l i b - P l u g i n s /�� �� � �  O K� �  T e s t� �  O K� �  O K�� � �  O K�� :�  	��
	 �� �� �� E��
�� 
sdsk
�� 
cfol � 
 U s e r s
�� 
cfol �  S h a r e d
�� 
cfol �  L a b l i b - P l u g i n s
�� 
cfol
 �  C r i t e r i o n   c o p y�ralis    n  JHRM                       ����H+  #8	build                                                          #8�L�        ����  	                Criterion copy    ����      �M [    #8	 �� �� �[  9JHRM:Users: Shared: Lablib-Plugins: Criterion copy: build     b u i l d  
  J H R M  0Users/Shared/Lablib-Plugins/Criterion copy/build  / ��  � ���� H H  !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\� �]]  C R . h �^^ , C R B e h a v i o r C o n t r o l l e r . h �__ , C R B e h a v i o r C o n t r o l l e r . m �``   C R B l o c k e d S t a t e . h �aa   C R B l o c k e d S t a t e . m �bb  C R C u e S t a t e . h �cc  C R C u e S t a t e . m �dd  C R D i g i t a l O u t . h �ee  C R D i g i t a l O u t . m �ff " C R E n d t r i a l S t a t e . h  �gg " C R E n d t r i a l S t a t e . m! �hh & C R E y e X Y C o n t r o l l e r . h" �ii & C R E y e X Y C o n t r o l l e r . m# �jj " C R F i x G r a c e S t a t e . h$ �kk " C R F i x G r a c e S t a t e . m% �ll  C R F i x a t e S t a t e . h& �mm  C R F i x a t e S t a t e . m' �nn  C R F i x o n S t a t e . h( �oo  C R F i x o n S t a t e . m) �pp  C R I d l e S t a t e . h* �qq  C R I d l e S t a t e . m+ �rr & C R I n t e r t r i a l S t a t e . h, �ss & C R I n t e r t r i a l S t a t e . m- �tt  C R P r e C u e S t a t e . m. �uu   C R P r e s t i m S t a t e . h/ �vv   C R P r e s t i m S t a t e . m0 �ww  C R R e a c t S t a t e . h1 �xx  C R R e a c t S t a t e . m2 �yy ( C R R o u n d T o S t i m C y c l e . h3 �zz ( C R R o u n d T o S t i m C y c l e . m4 �{{   C R S a c c a d e S t a t e . h5 �||   C R S a c c a d e S t a t e . m6 �}} ( C R S i g n a l C o n t r o l l e r . h7 �~~ ( C R S i g n a l C o n t r o l l e r . m8 � < C R S i g n a l C o n t r o l l e r . m . o r i g . o r i g9 ��� & C R S p i k e C o n t r o l l e r . h: ��� & C R S p i k e C o n t r o l l e r . m; ��� & C R S t a r t t r i a l S t a t e . h< ��� & C R S t a r t t r i a l S t a t e . m= ���  C R S t a t e S y s t e m . h> ���  C R S t a t e S y s t e m . m? ���  C R S t i m u l a t e . h@ ���  C R S t i m u l a t e . mA ���  C R S t i m u l i . hB ���  C R S t i m u l i . mC ���  C R S t o p S t a t e . hD ���  C R S t o p S t a t e . mE ��� * C R S u m m a r y C o n t r o l l e r . hF ��� * C R S u m m a r y C o n t r o l l e r . mG ���   C R T o o F a s t S t a t e . hH ���   C R T o o F a s t S t a t e . mI ���  C R U t i l i t i e s . hJ ���  C R U t i l i t i e s . mK ���   C R X T C o n t r o l l e r . hL ���   C R X T C o n t r o l l e r . mM ���  C r i t e r i o n . hN ���  C r i t e r i o n . mO ��� & C r i t e r i o n . x c o d e p r o jP ��� $ C r i t e r i o n _ P r e f i x . hQ ���  I n f o . p l i s tR ���  N o t e s . t x tS ��� " P l u g i n - I n f o . p l i s tT ��� $ U s e r D e f a u l t s . p l i s tU ���  m a i n . mV ��� 0 C R B e h a v i o r C o n t r o l l e r . x i bW ��� * C R E y e X Y C o n t r o l l e r . x i bX ��� , C R S i g n a l C o n t r o l l e r . x i bY ��� * C R S p i k e C o n t r o l l e r . x i bZ ��� . C R S u m m a r y C o n t r o l l e r . x i b[ ��� $ C R X T C o n t r o l l e r . x i b\ ���  C r i t e r i o n . x i b� ��� " I n f o P l i s t . s t r i n g s�� H�� C� ���  c r i t e r i o n� ���   X T C o n t r o l l e r . x i b
�� boovfals� ���  p a t h   =   C R� ���  p a t h   =   S D� ���  H E A D E R   =   C R� ���  H E A D E R   =   S D� ��� 0 n a m e   =   E n g l i s h . l p r o j \ / C R� ��� 0 n a m e   =   E n g l i s h . l p r o j \ / S D� ��� � c d   / U s e r s / S h a r e d / L a b l i b - P l u g i n s / S i g n a l D e t e c t i o n / ;   x c o d e b u i l d   - a l l t a r g e t s   c l e a n��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  �  �~  �}  �|  �{  �z  ascr  ��ޭ
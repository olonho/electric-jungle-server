<%@ page contentType="text/html; charset=UTF-8" %>


   <h2>Announcement</h2>
<p>This is a Java programming contest in which competitors will create algorithms of virtual creatures' group behavior, in which the creatures  fight for a limited energy resource or use it together. A wide range of client and server Java-technologies is utilized in this project.</p>
<h2>Laws of Electric Jungle</h2>
<h3>Notation</h3>
<ul>
    <li><code>X%ME</code> - Percentage of energy from the creature's maximum energy (ME)</li>

    <li><code>K_someconst</code>(5) - Constant that defines the game parameter (all the constants are defined in <code>Constants.java</code>). The current value is indicated in parentheses. While most of the constants will preserve these values, changes are possible </li>
</ul>
<h3>Concepts and Goals</h3>
<p>In the world of the Electric Jungle (EJ) the main goal is to maximize expansion.</p>
<p>Each player programs the behavior of his creatures so as to obtain the maximum results. The criteria for success are total biomass (the sum of the mass of all creatures) via a certain number of steps.</p>
<p>Space and time. In EJ, space is constructed as a two-dimensional field made of cells that encircles the exterior boundaries (thus forming a ring). Other topology and dimensions are also possible. Time is divided into separate steps, and each creature is given a chance to perform his actions: when he completes one step, the next step begins.   </p>
<p>Each creature in EJ has two basic characteristics: speed and mass. At each point in time his energy level is noted. The mass corresponds to the maximum energy (ME) that the creature can have. If the energy level falls below <code>K_emin(15%)</code> ME, the creature will die and all of his remaining energy will be available to other creatures. Mass can not be greater than <code>K_maxmass</code>(1000) or less than <code>K_minmass</code>(0.1). Speed cannot be greater than <code>K_maxspeed</code>(10) or less than <code>K_minspeed</code>(1).</p>

<p>Mass is defined by the number of points the participant has (biomass is the sum of the mass of all living creatures), power intensity and energy use per step, and any injuries sustained during battle.</p>
<p>Speed defines the maximum distance for a creature to move in one step. However, the higher the speed, the more energy a creature consumes to move. Regardless of speed, a creature can obtain information only about the point of its location, and about neighboring points.</p>
<p>Energy is the basis means of existence in EJ. Any action (even just surviving) requires some level of energy consumption.  Sources of energy are randomly placed on the field at the beginning of the game. Creatures can derive energy from these sources (no more than 10% of ME). Energy sources are renewed gradually. The initial amount of energy and its renewal speed are randomly specified and vary for different sources. There are <code>NUM_REGULAR(100)</code> of ordinary energy sources and <code>NUM_GOLDEN(3)</code> of golden sources on the field. The golden sources produce much more energy than the ordinary ones.<br />
</p>
<p>Outer world information. A creature can obtain outer world information by using the <code>BeingIntreface</code> and <code>PointInfo</code> APIs. The following information is available:</p>

<ul>
    <li>Amount of energy possessed by a creature</li>
    <li>Owner and weight of any neighbor creature (residing on the same cell or on adjacent cells)</li>
    <li>Amount of energy, its renewing speed, and the maximum capacity in the cell</li>
    <li>List of all objects in the point (in particular, the other creatures)</li>
    <li>Total weight of all living creatures at a given point</li>
</ul>

<h3>Actions and Events<br />
</h3>
<p>At each step a creature can perform only one action and  is notified about the events that are happening to it. The following actions are available (see <code>EventKind.java</code>):</p>
<ul>
    <li><code>ACTION_MOVE_TO</code> - Move to another cell. The availability of the cell is determined by the speed of the creature. The cost  is <code>K_movecost(1)%</code> of the speed.</li>
    <li><code>ACTION_EAT</code> - Consume energy. But cannot exceed the energy intensity and can't be greater than <code>K_bite(10)%</code> of the maximum energy (ME). Free of charge.</li>

    <li><code>ACTION_GIVE</code> - Transfer energy to another creature. Free of charge.</li>
    <li><code>ACTION_ATTACK</code> - Attack another creature, hurting that creature by  <code>K_fight(20)%</code> of the maximum energy (ME) (and lose its own energy by <code>K_fightcost(1)%</code>  + <code>K_retaliate(5)%</code> of the attacked creature's energy).</li>

    <li><code>ACTION_BORN</code> - Give birth to another creature. The child might be slightly different from the parent but can't exceed the parent in mass and speed (by more than K_minbornvariation(0.8)/K_maxbornvariation(1.2)). The energy is divided between the parent and the child. The act of birth is possible only if a creature has enough energy which is no less than K_toborn(80%). The act of birth costs K_borncost(20)% of the maximum energy (ME). In addition, the child can be granted its own 'genocode' (a new Java object of your choice). </li>
    <li><code>ACTION_MOVE_ATTACK</code> - Ability to move and attack at one time, the ability to hurt is reduced by <code>K_fightmovepenalty(0.75)</code>. The cost equates to the sum of the attack cost and the move cost.<br />
    </li>
</ul>
<p>The creature can get notifications about the following events:</p>

<ul>
    <li><code>BEING_BORN</code> - The first notification. The creature gets this notification when it is born. When a creature is born a number of parameters can be initialized.     </li>
    <li><code>BEING_DEAD</code> - The last notification. The creature gets this notification when it dies.</li>
    <li><code>BEING_ATTACKED</code> - The creature is being attacked by somebody. The ID of the attacker is transferred as a parameter.</li>
    <li><code>BEING_ENERGY_GIVEN</code> - Somebody has given the creature energy.</li>

</ul>
<h3>Game</h3>
<p>To begin the game, each player places one creature on a random spot in space and can optionally invoke the <code>reinit()</code> method, which can be done only once. The <code>reinit()</code> method provides information about the current conditions of the game and allows the reinitializing of static variables. The parameters of a particular creature are determined by the return value of the <code>Being.getParams()</code> method. The parameters of all other creatures are determined by the parameters of the <code>ACTION_BORN</code> action. Once born, each creature is able to win under given circumstances (see the details below).</p>

<p>Kinds of Games (see <code>GameKind.java</code>):</p>
<ol>
    <li>Blitzkrieg - <code>SINGLE</code><br />
    <p>One kind of species owns the whole world. The purpose is to get the highest score by using the resources in the most effective way and by performing the fastest exploration during a given time interval (200 steps).</p>
    </li>
    <li>Duel - <code>DUEL</code><br />

    <p>Two competing kinds of species. Attacks on creatures of different types are possible (1000 steps).</p>
    </li>
    <li>Jungle - <code>JUNGLE</code><br />
    <p>Up to 8 competing types acting together (2000 steps).</p>
    </li>
</ol>
<a name="contest"></a>
<h2>Competition</h2>

<p>The winner of the competition will be selected as follows:</p>
<ol>
    <li>To participate in the competition, register at <a href="http://electricjungle.ru/">http://electricjungle.ru/</a>, upload the JAR-file with executable code of your creature and mark it with a &quot;For contest&quot; sign. One participant may have not more than 10 creatures, among which not more than two creatures can be marked &quot;For contest&quot;.</li>
    <li>The automatic rating system will run daily contests in the &quot;duel&quot; mode for all creatures loaded in the base that are marked &quot;For contest&quot;. If your creature wins a duel, it gets one point, if nobody survives - nobody gets anything. A group of twenty leaders will be determined by the score every day. If two competitors have an equal amount of victories they will fight an additional duel.</li>

    <li>On January 22, 2007, the top five contestants will be chosen from the top twenty based on the results of dual matches.</li>
    <li>Within the top five, a system of duels will be held, and the  winner will receive the grand prize from Sun Microsystems. All final games will be recorded and broadcast in real time.</li>
</ol>
<p>In addition, the winner in the &quot;blitzkrieg&quot; category will be selected based on the absolute score among all the creatures, and in the &quot;jungle&quot; category the winner will be selected by the olympic system based on random sorting. These winners will also get prizes from Sun Microsystems.</p>
<h2>Technical Details</h2>

<h3>Coding</h3>
<p>The main goal of the competition participants is to implement the <tt>makeTurn()</tt> method of the <tt>Being</tt> interface. As an example, you can use the <tt>SimpleBeing</tt> class and start with the <tt>BeingTemplate</tt> template. You can write code in either the NetBeans IDE or any text editor (the engine can access the compiler to compile your code; for detailed instructions, see <tt>README.txt</tt>). The engine source code will be available to gamers. However, the final engine version used to choose the winner might differ from early versions.</p>

<strong>Note</strong>: Carefully read the <tt>Constants.java</tt> file as, along with the engine source, it contains important information about the world and is a valuable documentation source.<br />
<p>One week before the competition deadline, the engine source code will be frozen to let the players fine-tune their code to the final version.</p>
<h3>Security</h3>
<p>The game has a security system, which is disabled by default. Before the competition, you can check your creatures by starting the game with the <tt>&ndash;secure</tt> option and adding the contents of the <tt>java.policy</tt> file to the Java policy.</p>

<h3 class="hunderline">Tips and Notes</h3>
<ul>
    <li>The engine is optimized to run on multi-core and multi-processor machines, such as <a href="http://www.sun.com/processors/UltraSPARC-T1/">Niagara</a>. Thus, <tt>makeTurn()</tt> for one species can be simultaneously running on several cores or processors. Therefore, access to shared data (such as static variables) must be synchronized. Likewise, both <tt>makeTurn()</tt> and <tt>processEvent()</tt> must also be synchronized.</li>

    <li>Execution of <tt>makeTurn()</tt> should not take long. Otherwise, the engine deletes your creature from the playing area. Because the duration of timeouts depends on the number of active creatures and the overall server load, please avoid using complex time-consuming algorithms.</li>
</ul>

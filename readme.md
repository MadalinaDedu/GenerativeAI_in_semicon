## Concluzii

Lucrarea de față a explorat utilizarea **inteligenței artificiale generative** în dezvoltarea codului **Verilog** și a mediilor de testare **UVM**, având ca obiectiv principal **identificarea celor mai performante modele AI** în raport cu:
- eficiența,
- precizia generării de cod,
- influența asupra fluxului de lucru al inginerilor hardware.

Studiul comparativ, realizat pe o serie de modele generative *(inclusiv GPT-4o, BingAI, RapidGPT, Claude, LLaMA și altele)*, a evidențiat atât **potențialul** acestor instrumente, cât și **limitele actuale** în contextul dezvoltării hardware automatizate.

---

### Beneficii observate

Una dintre concluziile esențiale ale cercetării este că **utilizarea modelelor AI pentru generarea automată a codului RTL și UVM** poate aduce următoarele avantaje:
- **Economisirea timpului**, în multe cazuri;
- Generarea rapidă a componentelor funcționale;
- Respectarea parțială a specificațiilor tehnice;
- Sugestii utile pentru structura mediilor de verificare.

Totuși, **aceste instrumente nu pot înlocui expertiza unui inginer hardware**.

---

### Importanța promptului

Analiza comparativă a celor trei modele – **ChatGPT (pre-GPT-4o)**, **BingAI** și **RapidGPT** – a relevat că:

> **Calitatea promptului influențează direct calitatea codului generat.**

Principiul _"Garbage in, garbage out"_ se aplică strict:  
Un prompt vag sau incomplet → interpretări greșite → cod incorect sau inutil.

---

### Observații comparative

- **ChatGPT (versiunea anterioară GPT-4o)**: necesita prompturi foarte precise.
- **BingAI**: oferă rezultate mai coerente, în special dacă cerințele sunt bine definite.
- **RapidGPT**: s-a remarcat prin:
  - generare intuitivă de cod UVM;
  - rezultate mai „curate” (ex: utilizarea corectă a metodei `compare()` în scoreboard);
  - capacitatea de a sesiza **dependențele între componentele UVM**, sugerând automat instanțierea și conexiunile necesare.

Aceste calități ale RapidGPT au dus la un **număr redus de iterații** pentru obținerea unui testbench funcțional.

---

### Limitări și concluzie

Un aspect important observat:

> **Niciun model AI nu a generat complet și corect toate fișierele necesare doar pe baza unei descrieri funcționale.**

În toate cazurile, a fost necesară:
- **intervenție manuală** pentru corectarea erorilor,
- completarea funcțiilor lipsă,
- ajustarea logicii.

Deși AI-ul oferă un **punct de plecare util**, finalizarea codului a necesitat întotdeauna un **specialist uman**.

> În unele situații, **timpul pierdut pentru corectarea erorilor** a fost mai mare decât dacă s-ar fi scris codul de la zero.

Astfel, AI-ul poate fi un **asistent valoros**, dar **nu poate înlocui complet inginerul hardware**.

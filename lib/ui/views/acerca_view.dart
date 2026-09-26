import 'package:flutter/material.dart';

import 'package:pastillero_inteligente/models/integrante_model.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';
import 'package:pastillero_inteligente/ui/widgets/app_bar_custom.dart';
import 'package:pastillero_inteligente/ui/widgets/integrante_card.dart';
import 'package:pastillero_inteligente/ui/widgets/sidebar.dart';

class AcercaView extends StatelessWidget {
  const AcercaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(titulo: 'Acerca de'),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _header(),
            const SizedBox(height: 24),

            // ─── Versión ───────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified,
                      size: 14, color: AppColors.primaryDark),
                  SizedBox(width: 6),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ─── Misión ────────────────────────────────────
            _tarjetaInfo(
              icono: Icons.flag_outlined,
              titulo: 'Nuestra Mision',
              contenido:
                  'En VitaCode creemos que la salud no debe fallar por un olvido. '
                  'Nuestra mision es empoderar a medicos y pacientes con herramientas '
                  'digitales intuitivas que garanticen la adherencia a los tratamientos, '
                  'reduzcan errores en la administracion de medicamentos y mejoren la '
                  'calidad de vida de quienes dependen de una toma diaria. '
                  'Buscamos que la tecnologia sea un puente, no una barrera, '
                  'entre el cuidado profesional y el bienestar del paciente.',
            ),
            const SizedBox(height: 14),

            // ─── Visión ────────────────────────────────────
            _tarjetaInfo(
              icono: Icons.visibility_outlined,
              titulo: 'Nuestra Vision',
              contenido:
                  'Para 2030, VitaCode sera reconocida como la empresa lider en '
                  'Latinoamerica en soluciones de adherencia terapeutica y pastilleros '
                  'roboticos inteligentes. Aspiramos a conectar mas de 100,000 dispositivos '
                  'en hospitales, clinicas y hogares, siendo sinonimo de innovacion, '
                  'confiabilidad y calidez humana en el sector salud. '
                  'Queremos que cada paciente, sin importar su edad o condicion, '
                  'tenga acceso a un acompanamiento medico continuo y personalizado.',
            ),
            const SizedBox(height: 28),

            // ─── Equipo ────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Equipo VitaCode',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Toca a cada integrante para conocer mas',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            ...equipoVitaCode.map(
              (i) => IntegranteCard(integrante: i),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            // ─── Footer ────────────────────────────────────
            const Text(
              '"Tecnologia que cuida, salud que perdura"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '© 2026 VitaCode. Todos los derechos reservados.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.medication_liquid,
            size: 58,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Pastillero Inteligente',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'by ',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'VitaCode',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tarjetaInfo({
    required IconData icono,
    required String titulo,
    required String contenido,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icono, color: AppColors.primaryDark, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            contenido,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
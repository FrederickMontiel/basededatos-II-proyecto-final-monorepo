import { Entity, PrimaryGeneratedColumn, Column, OneToOne, JoinColumn, ManyToOne } from 'typeorm';
import { Actividad } from './actividad.entity';
import { EstadoActividad } from './estado-actividad.entity';

@Entity('detalle_reunion')
export class DetalleReunion {
  @PrimaryGeneratedColumn()
  id_detalle_reunion: number;

  @Column()
  id_actividad: number;

  @Column({ length: 150, nullable: true })
  calle: string;

  @Column({ length: 100, nullable: true })
  ciudad: string;

  @Column({ length: 100, nullable: true })
  sala: string;

  @Column({ nullable: true })
  id_estado_actividad: number;

  @OneToOne(() => Actividad, (actividad) => actividad.detalle_reunion)
  @JoinColumn({ name: 'id_actividad' })
  actividad: Actividad;

  @ManyToOne(() => EstadoActividad, (estado) => estado.detalles_reunion, { nullable: true })
  estado: EstadoActividad;
}

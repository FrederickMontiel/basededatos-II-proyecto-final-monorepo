import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Actividad } from './actividad.entity';
import { DetalleReunion } from './detalle-reunion.entity';

@Entity('estado_actividad')
export class EstadoActividad {
  @PrimaryGeneratedColumn()
  id_estado_actividad: number;

  @Column({ length: 50 })
  nombre_estado: string;

  @Column({ length: 255, nullable: true })
  descripcion: string;

  @Column({ default: true })
  estado: boolean;

  @OneToMany(() => Actividad, (actividad) => actividad.estado_actividad)
  actividades: Actividad[];

  @OneToMany(() => DetalleReunion, (detalle) => detalle.estado)
  detalles_reunion: DetalleReunion[];
}
